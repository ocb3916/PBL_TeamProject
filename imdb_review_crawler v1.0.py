from selenium import webdriver
import requests as re
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from bs4 import BeautifulSoup
import pandas as pd
from dotenv import load_dotenv
import os
import time

load_dotenv()

tmdb_access_token = os.getenv("TMDB_ACCESS_TOKEN")

headers = {
    "accept": "application/json",
    "Authorization": f"Bearer {tmdb_access_token}"
}

def save_processed_ids(processed_ids, filename="processed_tmdb_ids.txt"):
    """처리된 TMDb ID를 텍스트 파일에 저장"""
    with open(filename, 'a') as f:
        for movie_id in processed_ids:
            f.write(f"{movie_id}\n")

def load_processed_ids(filename="processed_tmdb_ids.txt"):
    """텍스트 파일에서 이미 처리된 TMDb ID를 로드"""
    try:
        with open(filename, 'r') as f:
            return set(line.strip() for line in f)
    except FileNotFoundError:
        return set()  # 파일이 없으면 빈 집합 반환

# TMDB에서 인기도 순으로 영화 목록 가져오기
def get_popular_movies(page=1, language='ko-KR'):
    print('starting get_popular_movies()...')
    global headers
    movies = []
    for page_num in range(1, page + 1):
        url = f"https://api.themoviedb.org/3/discover/movie?include_adult=true&include_video=false&language={language}&page={page_num}&sort_by=popularity.desc&vote_count.gte=200"
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
                'tmdb_id': movie['id'],
                'imdb_id': detail_data.get('imdb_id'),  # IMDb ID 추가
            })

    print('get_popular_movies() done.')
    return movies

def hide_spoiler(driver, wait):
    hide_spoiler_button = wait.until(EC.element_to_be_clickable((By.CSS_SELECTOR, '.ipc-boolean-input__input')))
    hide_spoiler_button.click()


def load_reviews(driver, imdb_id, threshold):
    url = f'https://www.imdb.com/title/{imdb_id}/reviews/?ref_=tt_ov_ql_2'
    wait = WebDriverWait(driver, 10)
    driver.get(url)
    print(f'starting load_reviews() at {url}...')

    try:
        hide_spoiler(driver, wait)
    except Exception as e:
        print("Spoiler button not found:", e)

    iterate = 0
    while iterate < threshold:
        try:
            load_more_button = wait.until(EC.element_to_be_clickable((By.CSS_SELECTOR, '.ipc-see-more__button')))
            driver.find_element(By.TAG_NAME, 'body').send_keys(Keys.END)
            time.sleep(1)
            load_more_button.click()
            time.sleep(2)
        except Exception:
            print("No more 'load more' button or an error occurred.")
            break
        iterate += 1

    return driver.page_source



def get_reviews(html):
    soup = BeautifulSoup(html, 'html.parser')
    articles = soup.select('[data-testid="review-card-parent"]')
    author_datas = soup.select('[data-testid="reviews-author"]')
    reviews = []

    for article, author_data in zip(articles, author_datas):
        try:
            rating = article.select_one('.ipc-rating-star--rating').get_text(strip=True)
        except AttributeError:
            rating = 'NULL'

        title = article.select_one('[data-testid="review-summary"]').get_text(strip=True)
        body = article.select_one('div.ipc-html-content-inner-div').get_text(strip=True)
        helpful_yes = article.select_one('.ipc-voting__label__count--up').get_text(strip=True)
        helpful_no = article.select_one('.ipc-voting__label__count--down').get_text(strip=True)
        author = author_data.select_one('[data-testid="author-link"]').get_text(strip=True)
        date = author_data.select_one('li.review-date').get_text(strip=True)

        reviews.append({
            "title": title,
            "rating": rating,
            "author": author,
            "date": date,
            "body": body,
            "helpful_yes": helpful_yes,
            "helpful_no": helpful_no,
        })

    return reviews

if __name__ == "__main__":
    start = time.time()
    print("Access Token:", tmdb_access_token)

    # 중복 처리된 ID 로드
    processed_ids = load_processed_ids()

    # 인기 영화 목록 가져오기
    page_num = input('인기 영화 목록 리뷰 크롤러: 인기 영화 n개에 대해 각 최대 x페이지 만큼 크롤링합니다.\n'
                     '제작: 컴퓨터공학과 2020010847 오찬빈\n'
                     '인기 영화 목록 페이지를 입력하세요(페이지 당 영화 20개): ')
    threshold_num = input('각 영화당 수집할 최대 리뷰 페이지를 입력하세요: ')
    popular_movies = get_popular_movies(page = int(page_num))

    all_reviews = []
    new_ids = set()  # 이번 실행에서 처리된 새로운 ID
    i = 0
    with webdriver.Chrome(service=Service(ChromeDriverManager().install())) as driver:
        for movie in popular_movies:
            i += 1
            tmdb_id = movie['tmdb_id']
            if tmdb_id in processed_ids:
                print(f"Skipping already processed movie: {movie['title']} (TMDb ID: {tmdb_id})")
                continue

            imdb_id = movie['imdb_id']
            if imdb_id:
                print(f'starting get_reviews({imdb_id})... [{i}/{len(popular_movies)}]')
                reviews = get_reviews(load_reviews(driver, imdb_id, int(threshold_num) - 1))
                for review in reviews:
                    review['movie_title'] = movie['title']
                    all_reviews.extend(reviews)

                new_ids.add(tmdb_id)

    # DataFrame 생성 후 CSV 파일로 저장
    if all_reviews:
        df = pd.DataFrame(all_reviews)
        df.to_json('popular_movies_reviews.json', orient="records", force_ascii=False, indent=4)
        print("json 파일이 'popular_movies_reivews.json' 이름으로 저장되었습니다.")
    else:
        print("추가된 리뷰가 없습니다.")

    # 새로운 TMDb ID 저장
    save_processed_ids(new_ids)
    print("새로운 TMDb ID가 'processed_tmdb_ids.txt'에 저장되었습니다.")

    print(f'수행시간: {time.time() - start: .0f}초')