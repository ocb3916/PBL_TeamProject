import 'dart:convert';
import 'package:untitled1/model/movie_model.dart';
import 'package:http/http.dart' as http;

class MovieData {
  final String baseUrl ='https://api.themoviedb.org/3/movie';
  final String bearerToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYjEzNDM0ZTM3YzU5YjI5MmU1NjJhYzNiMWNmZjBhOSIsIm5iZiI6MTcyODAzNDM1Ny40MzgzMTksInN1YiI6IjY2ZmZiNDE4OTI1ZmRmOTI1YjdjYzAxYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.12nn2eF2HxuoM3Ter1FSBXO87HDMCvOIupgxHmw4Nt4';

  Future<List<MovieModel>> fetchNowPlayingMovie() async {
    final response = await http.get(
      Uri.parse('$baseUrl/now_playing?language=ko-KR&page=1'),
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
      throw Exception("Failed to load movie data");
    }
  }

  Future<List<MovieModel>> fetchTopRatedMovie() async {
    final response = await http.get(
      Uri.parse('$baseUrl/top_rated?language=ko-KR&page=1'),
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
      throw Exception("Failed to load movie data");
    }
  }

  Future<List<MovieModel>> fetchPopularMovie() async {
    final response = await http.get(
      Uri.parse('$baseUrl/popular?language=ko-KR&page=1'),
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
      throw Exception("Failed to load popular movie data");
    }
  }
}
