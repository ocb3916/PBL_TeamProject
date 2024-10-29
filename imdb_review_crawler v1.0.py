from selenium import webdriver
import requests as re
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
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

def hide_spoiler(driver):
    hide_spoiler_button = driver.find_element(By.CSS_SELECTOR, '.ipc-boolean-input__input')
    hide_spoiler_button.click()


def load_reviews(imdb_id, threshold):
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()))
    url = f'https://www.imdb.com/title/{imdb_id}/reviews/?ref_=tt_ov_ql_2'

    print(f'Starting load_reviews() at {url} ...')

    wait = WebDriverWait(driver, 10)
    driver.get(url)

    hide_spoiler(driver)

    # "더보기" 버튼 클릭하여 모든 리뷰 로드
    iterate = 0
    while (iterate < threshold):
        try:
            load_more_button = wait.until(EC.element_to_be_clickable((By.CSS_SELECTOR, '.ipc-see-more__button')))
            driver.find_element(By.TAG_NAME, 'body').send_keys(Keys.END)
            time.sleep(1)
            load_more_button.click()
            time.sleep(2)
        except Exception as e:
            print("No more 'load more' button or an error occurred:")
            break
        iterate += 1

    # 페이지의 HTML 소스 가져오기
    html = driver.page_source
    driver.quit()

    return html


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
            reviews = get_reviews(load_reviews(imdb_id, int(threshold_num) - 1))
            for review in reviews:
                review['movie_title'] = movie['title']
                all_reviews.extend(reviews)

    # DataFrame 생성 후 CSV 파일로 저장
    df = pd.DataFrame(all_reviews)
    df.to_csv('IMDB_reviews.csv', index=False, encoding='utf-8-sig')
    print(f'수행시간: {time.time() - start: .0f}초')