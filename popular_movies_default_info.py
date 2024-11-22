import time
import requests
import pandas as pd
from dotenv import load_dotenv
import os

load_dotenv()

tmdb_access_token = os.getenv("TMDB_ACCESS_TOKEN")

headers = {
    "accept": "application/json",
    "Authorization": f"Bearer {tmdb_access_token}"
}

def get_popular_movies(page=1):
    url = f"https://api.themoviedb.org/3/discover/movie?include_adult=true&include_video=false&language=ko-KR&page={page}&sort_by=popularity.desc&vote_count.gte=200"
    response = requests.get(url, headers=headers)
    return response.json()['results']


def get_movie_details(movie_id):
    url = f'https://api.themoviedb.org/3/movie/{movie_id}?language=ko-KR&append_to_response=credits'
    response = requests.get(url, headers=headers)
    return response.json()


def get_watch_providers(movie_id):
    url = f'https://api.themoviedb.org/3/movie/{movie_id}/watch/providers'
    response = requests.get(url, headers=headers)
    providers_data = response.json().get('results', {})
    kr_providers = providers_data.get('KR', {}).get('flatrate', [])
    if not kr_providers:
        kr_providers = providers_data.get('KR', {}).get('rent', [])
        return [provider['provider_name'] for provider in kr_providers] if kr_providers else ["정보 없음"]
    return [provider['provider_name'] for provider in kr_providers] if kr_providers else ["정보 없음"]


def get_age_rating(movie_id):
    url = f'https://api.themoviedb.org/3/movie/{movie_id}/release_dates'
    response = requests.get(url, headers=headers)
    certification_data = response.json().get('results', {})
    for country in certification_data:
        if country['iso_3166_1'] == 'KR':  # 한국 연령 등급만 추출
            for release in country['release_dates']:
                return release.get('certification', '정보 없음')
    return '정보 없음'  # 연령 등급 정보가 없는 경우


if __name__ == "__main__":
    start = time.time()
    movie_data = []

    for page in range(1, 3):
        popular_movies = get_popular_movies(page)

        for movie in popular_movies:
            movie_id = movie['id']
            details = get_movie_details(movie_id)

            # 기본 정보
            title = details['title']
            tmdb_id = details['id']
            synopsis = details['overview']
            rating = details['vote_average']
            popularity = details['popularity']
            runtime = details.get('runtime', '정보 없음')  # 러닝타임 정보
            poster_url = f"https://image.tmdb.org/t/p/w500{details['poster_path']}"
            genres = [genre['name'] for genre in details['genres']]
            certification = get_age_rating(movie_id)
            watch_providers = get_watch_providers(movie_id)  # 시청 가능한 OTT 서비스 정보

            # 출연진 정보 (전체 출연진 최대 9명)
            cast_list = [(cast['name'], cast['character']) for cast in details['credits']['cast'][:9]]

            # 감독 정보
            director = next((crew['name'] for crew in details['credits']['crew'] if crew['job'] == 'Director'), 'N/A')

            # 영화 정보를 딕셔너리 형태로 저장
            movie_data.append({
                "movie_title": title,
                "TMDB_ID": tmdb_id,
                "age_rating": certification,
                "synopsis": synopsis,
                "rating": rating,
                "tmdb_score": popularity,
                "runtime": runtime,
                "poster_URL": poster_url,
                "genres": ', '.join(genres),
                "director": director,
                "watch_providers": ', '.join(watch_providers),
                "cast": ', '.join([f"{name} ({character})" for name, character in cast_list])
            })

    # DataFrame으로 변환
    df = pd.DataFrame(movie_data)

    # CSV 파일로 저장
    df.to_json("popular_movies_default_info.json", orient="records", force_ascii=False, indent=4)

    print("json 파일이 'popular_movies_default_info.json' 이름으로 저장되었습니다.")
    print(f'수행시간: {time.time() - start: .0f}초')