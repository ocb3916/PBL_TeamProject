import requests
from bs4 import BeautifulSoup
import time
import pandas as pd
from tqdm import tqdm
import os
from dotenv import load_dotenv
from lxml import html
import json

load_dotenv()

tmdb_access_token = os.getenv("TMDB_ACCESS_TOKEN")

headers = {
    "accept": "application/json",
    "Authorization": f"Bearer {tmdb_access_token}"
}

def save_processed_ids(processed_ids, filename="processed_tv_ids.txt"):
    """처리된 TMDb ID를 텍스트 파일에 저장"""
    with open(filename, 'a') as f:
        for tv_id in processed_ids:
            f.write(f"{tv_id}\n")

def load_processed_ids(filename="processed_tv_ids.txt"):
    """텍스트 파일에서 이미 처리된 TMDb ID를 로드"""
    try:
        with open(filename, 'r') as f:
            return set(line.strip() for line in f)
    except FileNotFoundError:
        return set()  # 파일이 없으면 빈 집합 반환

def get_popular_tv(page, country):
    url = f"https://api.themoviedb.org/3/discover/tv?first_air_date_year=2024&include_adult=true&include_null_first_air_dates=false&language=ko-KR&page={page}&sort_by=popularity.desc&watch_region=KR&with_origin_country={country}&with_watch_providers=8%7C356%7C337"
    response = requests.get(url, headers=headers)
    return response.json()['results']

def get_popular_long_run_tv(country):
    url = f"https://api.themoviedb.org/3/discover/tv?air_date.gte=2024-01-01&include_adult=true&include_null_first_air_dates=false&language=ko-KR&page=1&sort_by=popularity.desc&watch_region=KR&with_origin_country={country}&with_watch_providers=8%7C337%7C356"
    response = requests.get(url, headers=headers)
    return response.json()['results']

def get_imdb_id(tv_id):
    url = f"https://api.themoviedb.org/3/tv/{tv_id}/external_ids"
    response = requests.get(url, headers=headers)
    return response.json()['imdb_id']

def get_reviews(imdb_id, iterate=0): # iterate 만큼 '더 보기' 버튼 클릭 후 추가 리뷰 수집
    time.sleep(1)
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36'
    }
    url = f'https://www.imdb.com/title/{imdb_id}/reviews/?ref_=tt_ov_ql_2&spoilers=EXCLUDE'
    response = requests.get(url, headers=headers)

    soup = BeautifulSoup(response.text, 'lxml')
    articles = soup.select('[data-testid="review-card-parent"]')
    reviews = []

    # '__NEXT_DATA__' 스크립트 태그 찾기
    script_tag = soup.find('script', {'id': '__NEXT_DATA__'})

    # JSON 데이터를 로드
    data = json.loads(script_tag.string)

    # endCursor 값 추출
    end_cursor = data['props']['pageProps']['contentData']['data']['title']['reviews']['pageInfo']['endCursor']

    # 모든 리뷰 추출
    all_reviews = data['props']['pageProps']['contentData']['data']['title']['reviews']['edges']

    if not articles:
        print("There is no review or HTML structure might have changed.")
        return []

    for review in all_reviews:
        node = review['node']
        title = node['summary']['originalText']

        # rating 예외처리 (값이 없거나 None인 경우)
        rating = node['authorRating'] if node['authorRating'] is not None else 'No Rating'

        author = node['author']['nickName']
        date = node['submissionDate']
        body = node['text']['originalText']['plaidHtml']  # body에서 HTML 엔티티 변환
        tree = html.fromstring(body)
        cleaned_body = tree.text_content()  # HTML 엔티티를 변환
        helpful_yes = node['helpfulness']['upVotes']
        helpful_no = node['helpfulness']['downVotes']

        # 데이터 저장
        reviews.append({
            'title': title,
            'rating': rating,
            'author': author,
            'date': date,
            'body': cleaned_body,
            'helpful_yes': helpful_yes,
            'helpful_no': helpful_no
        })

    i=0
    if end_cursor:
        while i < iterate:
            review_temp, end_cursor = get_more_reviews(imdb_id, end_cursor)
            reviews.extend(review_temp)
            i += 1
    else:
        print("There is no more page.")

    return reviews

def get_more_reviews(imdb_id, end_cursor):
    time.sleep(1)
    url = "https://caching.graphql.imdb.com/"
    after = end_cursor
    payload = {
        "operationName": "TitleReviewsRefine",
        "variables": {
            "after": f"{after}", # 이 값은 DOM에서 endCursor 값을 찾아야 함
            "const": f"{imdb_id}",  # imdb-id
            "filter": {"spoiler": "EXCLUDE"},
            "first": 25,
            "locale": "ko-KR",
            "sort": {"by": "HELPFULNESS_SCORE", "order": "DESC"}
        },
        "extensions": {
            "persistedQuery": {
                "sha256Hash": "89aff4cd7503e060ff1dd5aba91885d8bac0f7a21aa1e1f781848a786a5bdc19",
                "version": 1
            }
        }
    }

    # POST 요청 실행
    headers = {"Content-Type": "application/json"}  # JSON 요청임을 명시
    response = requests.post(url, headers=headers, data=json.dumps(payload))

    # JSON 파싱
    parsed_data = response.json()

    # 리뷰 데이터 추출
    reviews = parsed_data['data']['title']['reviews']['edges']
    end_cursor = parsed_data['data']['title']['reviews']['pageInfo']['endCursor']

    # 결과 리스트
    extracted_data = []

    # 리뷰 데이터에서 필요한 정보 추출
    for review in reviews:
        node = review['node']
        title = node['summary']['originalText']

        # rating 예외처리 (값이 없거나 None인 경우)
        rating = node['authorRating'] if node['authorRating'] is not None else 'No Rating'

        author = node['author']['nickName']
        date = node['submissionDate']
        body = node['text']['originalText']['plaidHtml']  # body에서 HTML 엔티티 변환
        tree = html.fromstring(body)
        cleaned_body = tree.text_content()  # HTML 엔티티를 변환
        helpful_yes = node['helpfulness']['upVotes']
        helpful_no = node['helpfulness']['downVotes']

        # 데이터 저장
        extracted_data.append({
            'title': title,
            'rating': rating,
            'author': author,
            'date': date,
            'body': cleaned_body,
            'helpful_yes': helpful_yes,
            'helpful_no': helpful_no
        })

    return extracted_data, end_cursor

if __name__ == "__main__":
    start = time.time()
    print("Access Token:", tmdb_access_token)

    # 중복 처리된 ID 로드
    processed_ids = load_processed_ids()

    countries = ["KR", "JP", "US"]
    tv_ids = []  # the list of (tmdb-id, imdb-id)
    all_reviews = []
    collected_tv_ids = set()

    for country in countries:
        for page in range(1, 5):
            popular_tv = get_popular_tv(page, country)

            for tv in tqdm(popular_tv, desc=f"{country} 인기 tv 프로그램 imdb-id 수집 {page}/4"):
                tv_id = tv['id']  # tmdb-id
                imdb_id = get_imdb_id(tv_id)
                if imdb_id:
                    tv_ids.append((tv_id, imdb_id))
                collected_tv_ids.add(tv_id)

    for country in countries:
        popular_tv = get_popular_long_run_tv(country)

        for tv in tqdm(popular_tv, desc=f"{country} 인기 장수 tv imdb-id 정보 수집"):
            tv_id = tv['id']  # tmdb-id
            if tv_id not in collected_tv_ids:
                imdb_id = get_imdb_id(tv_id)
                if imdb_id:
                    tv_ids.append((tv_id, imdb_id))
                collected_tv_ids.add(tv_id)

    # 리뷰 수집
    i = 0
    for tmdb_id, imdb_id in tv_ids:
        i += 1
        print(f'https://www.imdb.com/title/{imdb_id}/reviews/?ref_=tt_ov_ql_2&spoilers=EXCLUDE 리뷰 수집 중 ({i}/{len(tv_ids)})')
        if str(tmdb_id) in processed_ids:
            print(f"Skipping already processed tv https://www.themoviedb.org/tv/{tmdb_id}")
            continue

        reviews = get_reviews(imdb_id, 1)
        for review in reviews:
            review['tmdb-id'] = tmdb_id
        all_reviews.extend(reviews)

    # DataFrame 생성 후 json 파일로 저장
    if all_reviews:
        df = pd.DataFrame(all_reviews)
        df.to_json('popular_tv_series_reviews.json', orient="records", force_ascii=False, indent=4)
        print("json 파일이 'popular_tv_series_reviews.json' 이름으로 저장되었습니다.")
    else:
        print("추가된 리뷰가 없습니다.")

    # 새로운 TMDb ID 저장
    save_processed_ids(collected_tv_ids)
    print("새로운 TMDb ID가 'processed_tv_ids.txt'에 저장되었습니다.")

    print(f'수행시간: {time.time() - start: .0f}초')
