import requests as re
from bs4 import BeautifulSoup
from urllib.parse import urljoin
import pandas as pd
import time

base_url = "https://www.imdb.com/"
key = ""

MAX_CNT = 1000
cnt = 0

def get_reviews(soup):
    global cnt
    reviews = []
    review_items = soup.find_all('div', class_='lister-item-content')

    for item in review_items:
        cnt += 1
        rate = item.find('span', class_='rating-other-user-rating')
        if rate:
            rate = rate.find('span').get_text(strip=True)
        else:
            rate = 'No rating'
        
        title = item.find('a').get_text(strip=True)
        writer = item.find('span', class_='display-name-link').get_text(strip=True)
        date = item.find('span', class_='review-date').get_text(strip=True)
        content = item.find('div', class_='text show-more__control').get_text(strip=True)

        reviews.append({
            'title': title,
            'writer': writer,
            'date': date,
            'rate': rate,
            'content': content
        })

    return reviews

if __name__ == "__main__":
    url = 'https://www.imdb.com/title/tt6751668/reviews/?ref_=tt_ql_urv'
    res = re.get(url, headers={'User-agent': 'Mozila/5.0'})

    soup = BeautifulSoup(res.text, 'html.parser')

    # 첫 페이지 리뷰 가져오기
    all_reviews = get_reviews(soup)

    load_more = soup.find_all('div', class_='load-more-data')
    # "더보기" 버튼 처리
    while not(load_more):
        res = re.get(url, headers={'User-agent':'Mozila/5.0'})
        soup = BeautifulSoup(res.text, 'html.parser')

        load_more = soup.find_all('div', class_='load-more-data')

    first_time = True
    while load_more:
        if first_time:
            ajaxurl = load_more[0]['data-ajaxurl'] #data-ajaxurl은 최초 한 번만 가져오면 된다.
            base_url = base_url + ajaxurl + "?ref_=undefined&paginationKey="
            first_time = False
        key = load_more[0]['data-key']

        # AJAX 요청을 통해 추가 리뷰 가져오기
        res = re.get(base_url + key, headers={'User-agent': 'Mozilla/5.0'})
        soup = BeautifulSoup(res.text, 'html.parser')

        # 추가 리뷰를 가져와서 기존 리뷰에 추가
        all_reviews.extend(get_reviews(soup))

        if cnt >= MAX_CNT:
            break

        # 다시 "더보기" 버튼 확인
        load_more = soup.select(".load-more-data")

    '''# 모든 리뷰 출력
    for review in all_reviews:
        print(f"title: {review['title']}\nwriter: {review['writer']}\ndate: {review['date']}\nrate: {review['rate']}\ncontent: {review['content']}\n")

    print(len(all_reviews))'''

    review_data = []
    # 각 리뷰에 대해 처리
    for review in all_reviews:
        review_data.append({
            'title': review['title'],
            'writer': review['writer'],
            'date': review['date'],
            'rate': review['rate'],
            'content': review['content']
        })
    df = pd.DataFrame(review_data)

    df.to_csv('IMDB_reviews.csv')