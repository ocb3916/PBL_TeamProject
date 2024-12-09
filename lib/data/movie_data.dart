import 'dart:convert';
import 'package:untitled1/model/movie_model.dart';
import 'package:untitled1/model/cast_model.dart';
import 'package:http/http.dart' as http;

class MovieData {
  final String baseUrl ='https://api.themoviedb.org/3/movie';
  final String bearerToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYjEzNDM0ZTM3YzU5YjI5MmU1NjJhYzNiMWNmZjBhOSIsIm5iZiI6MTcyODAzNDM1Ny40MzgzMTksInN1YiI6IjY2ZmZiNDE4OTI1ZmRmOTI1YjdjYzAxYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.12nn2eF2HxuoM3Ter1FSBXO87HDMCvOIupgxHmw4Nt4';
  final int defaultPageCount = 20;

  Future<MovieModel> fetchMovieById(int movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$movieId?language=ko-KR'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return MovieModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load movie');
    }
  }

  Future<List<MovieModel>> fetchMovies(String endpoint, {int? pageCount}) async {
    int pages = pageCount ?? defaultPageCount; // 페이지 수가 null인 경우 기본 값을 사용
    List<MovieModel> allMovies = [];
    for (int i = 1; i <= pages; i++) {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint?language=ko-KR&region=KR&&page=$i'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        allMovies.addAll(((jsonDecode(response.body)['results']) as List)
            .map((e) => MovieModel.fromJson(e))
            .toList());
      } else {
        throw Exception("Failed to load movie data");
      }
    }
    return allMovies;
  }

  Future<List<MovieModel>> fetchNowPlayingMovies({int? pageCount}) async {
    return fetchMovies('now_playing', pageCount: pageCount);
  }


  Future<List<MovieModel>> fetchPopularMovies({int? pageCount}) async {
    return fetchMovies('popular', pageCount: pageCount);
  }

  Future<MovieModel> fetchMovieDetail(int movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$movieId?language=ko-KR'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      MovieModel model = MovieModel.fromJson(jsonDecode(response.body));
      return MovieModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load movie detail");
    }
  }
  Future<List<MovieModel>> fetchSimilarMovies(int movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$movieId/similar?language=en-US&page=1'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return ((jsonDecode(response.body)['results']) as List)
          .map((e) => MovieModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load similar movies");
    }
  }
  Future<List<CastModel>> fetchCastDetails(int movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$movieId/credits?language=ko-KR'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List castList = jsonDecode(response.body)['cast']; // 출연진 데이터 추출
      return castList.map((cast) => CastModel.fromJson(cast)).toList(); // CastModel 리스트 반환
    } else {
      throw Exception("Failed to load cast details");
    }
  }

  Future<List<MovieModel>> fetchTrendingMovies() async {
    List<MovieModel> trendingMovies = [];
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/trending/movie/day?language=ko-KR'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'accept': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      trendingMovies.addAll(((jsonDecode(response.body)['results']) as List)
          .map((e) => MovieModel.fromJson(e))
          .toList());
    } else {
      throw Exception("Failed to load trending movies");
    }

    return trendingMovies;
  }


  Future<List<MovieModel>> fetchConsistentlyPopularMovies({int? pageCount}) async {
    int pages = pageCount ?? defaultPageCount;
    List<MovieModel> popularMovies = [];
    for (int i = 1; i <= pages; i++) {
      final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/discover/movie?release_date.gte=2024-01-01&include_adult=true&include_null_first_air_dates=false&language=ko-KR&page=$i&sort_by=popularity.desc&watch_region=KR&with_origin_country=KR&with_watch_providers=8%7C337%7C356'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        popularMovies.addAll(((jsonDecode(response.body)['results']) as List)
            .map((e) => MovieModel.fromJson(e))
            .toList());
      } else {
        throw Exception("Failed to load consistently popular movies");
      }
    }
    return popularMovies;
  }

  Future<List<MovieModel>> fetchTopRatedMovies({int? pageCount}) async {
    int pages = pageCount ?? defaultPageCount;
    List<MovieModel> topRatedMovies = [];
    for (int i = 1; i <= pages; i++) {
      final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/discover/movie?include_adult=true&include_null_first_air_dates=false&language=ko-KR&page=$i&sort_by=vote_average.desc&watch_region=KR&with_origin_country=KR&with_watch_providers=8%7C337%7C356'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        topRatedMovies.addAll(((jsonDecode(response.body)['results']) as List)
            .map((e) => MovieModel.fromJson(e))
            .toList());
      } else {
        throw Exception("Failed to load top rated movies");
      }
    }
    return topRatedMovies;
  }

  Future<List<MovieModel>> fetchRecentlyReleasedMovies({int? pageCount}) async {
    int pages = pageCount ?? defaultPageCount;
    List<MovieModel> recentlyReleasedMovies = [];
    for (int i = 1; i <= pages; i++) {
      final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/discover/movie?release_date.gte=2024-01-01&include_adult=true&include_null_first_air_dates=false&language=ko-KR&page=$i&sort_by=primary_release_date.desc&watch_region=KR&with_origin_country=KR%7CUS%7CJP&with_watch_providers=8%7C337%7C356'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        recentlyReleasedMovies.addAll(((jsonDecode(response.body)['results']) as List)
            .map((e) => MovieModel.fromJson(e))
            .toList());
      } else {
        throw Exception("Failed to load recently released movies");
      }
    }
    return recentlyReleasedMovies;
  }

  Future<List<MovieModel>> fetchDisneyPlusMovies({int? pageCount}) async {
    int pages = pageCount ?? defaultPageCount;
    List<MovieModel> disneyPlusMovies = [];
    for (int i = 1; i <= pages; i++) {
      final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/discover/movie?include_adult=true&include_null_first_air_dates=false&language=ko-KR&page=$i&sort_by=popularity.desc&watch_region=KR&with_watch_providers=337&with_origin_country=KR%7CUS%7CJP'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        disneyPlusMovies.addAll(((jsonDecode(response.body)['results']) as List)
            .map((e) => MovieModel.fromJson(e))
            .toList());
      } else {
        throw Exception("Failed to load Disney Plus movies");
      }
    }
    return disneyPlusMovies;
  }

  Future<List<MovieModel>> fetchNetflixMovies({int? pageCount}) async {
    int pages =  pageCount ?? defaultPageCount;
    List<MovieModel> NetflixMovies = [];
    for (int i = 1; i <= pages; i++) {
      final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/discover/movie?include_adult=true&include_null_first_air_dates=false&language=ko-KR&page=$i&sort_by=popularity.desc&watch_region=KR&with_watch_providers=8&with_origin_country=KR%7CUS%7CJP'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        NetflixMovies.addAll(((jsonDecode(response.body)['results']) as List)
            .map((e) => MovieModel.fromJson(e))
            .toList());
      } else {
        throw Exception("Failed to load Netflix movies");
      }
    }
    return NetflixMovies;
  }

  Future<List<MovieModel>> fetchMoviesFromEndpoints(List<String> urls, {int? pageCount}) async {
  List<MovieModel> allMovies = [];
  int pages = pageCount ?? defaultPageCount;
  // 페이지 수가 null인 경우 기본 값을 사용
  for (String url in urls) {
  for (int page = 1; page <= pages; page++) {
  final response = await http.get(
  Uri.parse('$url&page=$page'),
  headers: {
  'Authorization': 'Bearer $bearerToken',
  'accept': 'application/json',
  },
  );

  if (response.statusCode == 200) {
  List<MovieModel> movies = ((jsonDecode(response.body)['results']) as List)
      .map((e) => MovieModel.fromJson(e))
      .toList();
  allMovies.addAll(movies);
  } else {
  print("Failed to load movies from $url: ${response.statusCode}");
  }
  }
  }

  return allMovies;
  }

  Future<List<MovieModel>> fetchCombinedMovies({int? pageCount}) async {
  int pages = pageCount ?? defaultPageCount; // 페이지 수가 null인 경우 기본 값을 사용
  List<String> urls = [
  'https://api.themoviedb.org/3/discover/movie?include_adult=true&include_video=false&language=ko-KR&sort_by=popularity.desc&vote_count.gte=200',
  'https://api.themoviedb.org/3/discover/movie?first_air_date_year=2024&include_adult=true&include_null_first_air_dates=false&language=ko-KR&sort_by=popularity.desc&watch_region=KR&with_origin_country=KR%7CUS%7CJP&with_watch_providers=8%7C356%7C337',
  'https://api.themoviedb.org/3/discover/movie?air_date.gte=2024-01-01&include_adult=true&include_null_first_air_dates=false&language=ko-KR&sort_by=popularity.desc&watch_region=KR&with_origin_country=KR%7CUS%7CJP&with_watch_providers=8%7C337%7C356'
  ];

  List<MovieModel> combinedMovies = await fetchMoviesFromEndpoints(urls, pageCount: pages);
  return combinedMovies.toSet().toList(); // 중복 제거
  }

  Future<List<MovieModel>> fetchMoviesBySort(String sortBy, {int? pageCount}) async {
    int pages = pageCount ?? defaultPageCount; // 페이지 수가 null인 경우 기본 값을 사용
    List<String> urls = [];

    switch (sortBy) {
      case 'vote_average.desc':
        urls = [
          'https://api.themoviedb.org/3/discover/movie?include_adult=true&include_video=false&language=ko-KR&sort_by=vote_average.desc&vote_count.gte=200',
          'https://api.themoviedb.org/3/discover/movie?first_air_date_year=2024&include_adult=true&include_null_first_air_dates=false&language=ko-KR&sort_by=vote_average.desc&watch_region=KR&with_origin_country=KR%7CUS%7CJP&with_watch_providers=8%7C356%7C337',
          'https://api.themoviedb.org/3/discover/movie?air_date.gte=2024-01-01&include_adult=true&include_null_first_air_dates=false&language=ko-KR&sort_by=vote_average.desc&watch_region=KR&with_origin_country=KR%7CUS%7CJP&with_watch_providers=8%7C337%7C356'
        ];
        break;
      case 'primary_release_date.desc':
        urls = [
          'https://api.themoviedb.org/3/discover/movie?include_adult=true&include_video=false&language=ko-KR&sort_by=primary_release_date.desc&vote_count.gte=200',
          'https://api.themoviedb.org/3/discover/movie?first_air_date_year=2024&include_adult=true&include_null_first_air_dates=false&language=ko-KR&sort_by=primary_release_date.desc&watch_region=KR&with_origin_country=KR%7CUS%7CJP&with_watch_providers=8%7C356%7C337',
          'https://api.themoviedb.org/3/discover/movie?air_date.gte=2024-01-01&include_adult=true&include_null_first_air_dates=false&language=ko-KR&sort_by=primary_release_date.desc&watch_region=KR&with_origin_country=KR%7CUS%7CJP&with_watch_providers=8%7C337%7C356'
        ];
        break;
      case 'popularity.desc':
        urls = [
          'https://api.themoviedb.org/3/discover/movie?include_adult=true&include_video=false&language=ko-KR&sort_by=popularity.desc&vote_count.gte=200',
          'https://api.themoviedb.org/3/discover/movie?first_air_date_year=2024&include_adult=true&include_null_first_air_dates=false&language=ko-KR&sort_by=popularity.desc&watch_region=KR&with_origin_country=KR%7CUS%7CJP&with_watch_providers=8%7C356%7C337',
          'https://api.themoviedb.org/3/discover/movie?air_date.gte=2024-01-01&include_adult=true&include_null_first_air_dates=false&language=ko-KR&sort_by=popularity.desc&watch_region=KR&with_origin_country=KR%7CUS%7CJP&with_watch_providers=8%7C337%7C356'
        ];

        break;
    }

    List<MovieModel> sortedMovies = await fetchMoviesFromEndpoints(urls, pageCount: pages);
    return sortedMovies.toSet().toList(); // 중복 제거
  }
}


