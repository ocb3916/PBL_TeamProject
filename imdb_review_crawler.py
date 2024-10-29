import requests as re
from bs4 import BeautifulSoup
from urllib.parse import urljoin
import pandas as pd
from dotenv import load_dotenv
import os
import time

load_dotenv()

tmdb_api_key = os.getenv("TMDB_API_KEY")
tmdb_access_token = os.getenv("TMDB_ACCESS_TOKEN")

headers = {
    "accept": "application/json",
    "Authorization": f"Bearer {tmdb_access_token}"
}

# TMDB에서 인기도 순으로 영화 목록 가져오기
def get_popular_movies(page=1, language='ko-KR'):
    print('starting get_popular_movies()...')
    global headers
    movies = []
    for page_num in range(1, page + 1):
        url = f"https://api.themoviedb.org/3/discover/movie?include_adult=true&include_video=false&language={language}&page={page_num}&sort_by=popularity.desc&vote_count.gte=50"
        response = re.get(url, headers=headers)
        data = response.json()

        for movie in data['results']:
            movie_id = movie['id']
            # 각 영화의 상세 정보 요청
            detail_url = f"https://api.themoviedb.org/3/movie/{movie_id}?language={language}"
            detail_response = re.get(detail_url, headers=headers)
            detail_data = detail_response.json()

            movies.append({
                'title': movie['title'],
                'imdb_id': detail_data.get('imdb_id'),  # IMDb ID 추가
            })

    print('get_popular_movies() done.')
    return movies

def get_reviews(imdb_id, threshold):
    base_url = "https://www.imdb.com/"
    url = f'https://www.imdb.com/title/{imdb_id}/reviews/?ref_=tt_ql_2'
    res = re.get(url, headers={'User-agent': 'Mozila/5.0'})

    soup = BeautifulSoup(res.text, 'html.parser')

    def current_reviews(soup):
        current_reviews = []
        review_items = soup.find_all('div', class_='lister-item-content')

        for item in review_items:
            rate = item.find('span', class_='rating-other-user-rating')
            if rate:
                rate = rate.find('span').get_text(strip=True)
            else:
                rate = 'No rating'

            title = item.find('a').get_text(strip=True)
            writer = item.find('span', class_='display-name-link').get_text(strip=True)
            date = item.find('span', class_='review-date').get_text(strip=True)
            content = item.find('div', class_='text show-more__control').get_text(strip=True)

            current_reviews.append({
                'title': title,
                'writer': writer,
                'date': date,
                'rate': rate,
                'content': content
            })

        return current_reviews

    # 첫 페이지 리뷰 가져오기
    reviews = current_reviews(soup)

    load_more = soup.find_all('div', class_='load-more-data')
    # "더보기" 버튼 처리
    while not (load_more):
        res = re.get(url, headers={'User-agent': 'Mozila/5.0'})
        soup = BeautifulSoup(res.text, 'html.parser')

        load_more = soup.find_all('div', class_='load-more-data')

    first_time = True
    iterate = 0
    while load_more:
        print(f'finding load_more button... iterate = {iterate}')
        if first_time:
            ajaxurl = load_more[0]['data-ajaxurl']  # data-ajaxurl은 최초 한 번만 가져오면 된다.
            base_url = base_url + ajaxurl + "?ref_=undefined&paginationKey="
            first_time = False

        try:
            key = load_more[0]['data-key']
        except:
            print(f'imdb_id = {imdb_id} has no load_more button. checkout at this url: {url}')
            break

        # AJAX 요청을 통해 추가 리뷰 가져오기
        res = re.get(base_url + key, headers={'User-agent': 'Mozilla/5.0'})
        soup = BeautifulSoup(res.text, 'html.parser')

        # 추가 리뷰를 가져와서 기존 리뷰에 추가
        reviews.extend(current_reviews(soup))

        if iterate == threshold:
            break

        # 다시 "더보기" 버튼 확인
        load_more = soup.select(".load-more-data")
        iterate += 1
        time.sleep(1)

    return reviews

if __name__ == "__main__":
    start = time.time()
    print("API Key:", tmdb_api_key)
    print("Access Token:", tmdb_access_token)
    # 인기 영화 목록 가져오기
    page_num = input('인기 영화 목록 리뷰 크롤러: 원하는 페이지 숫자를 입력하면 해당 페이지 만큼 리뷰를 크롤링 합니다.\n'
                     '제작: 컴퓨터공학과 2020010847 오찬빈\n'
                     '원하시는 페이지 숫자를 입력해주세요.(페이지 당 영화 20개): ')
    threshold_num = input('각 영화마다 최대 몇 페이지까지 리뷰를 크롤링 할지 정해주세요: ')
    popular_movies = get_popular_movies(page = int(page_num))

    all_reviews = []
    i = 0
    for movie in popular_movies:
        i += 1
        imdb_id = movie['imdb_id']
        if imdb_id:
            print(f'starting get_reviews({imdb_id})... [{i}/{len(popular_movies)}]')
            reviews = get_reviews(imdb_id, int(threshold_num) - 1)
            for review in reviews:
                review['movie_title'] = movie['title']
                all_reviews.extend(reviews)

    # DataFrame 생성 후 CSV 파일로 저장
    df = pd.DataFrame(all_reviews)
    df.to_csv('IMDB_reviews.csv', index=False, encoding='utf-8-sig')
    print(f'수행시간: {time.time() - start: .0f}초')