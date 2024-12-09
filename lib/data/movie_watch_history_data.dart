import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/movie_watch_history.dart';

class MovieWatchHistoryData {
  final String baseUrl = 'https://contentspick.site/api/movie-watch-histories';

  Future<List<MovieWatchHistory>> fetchMovieWatchHistories(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body) ?? [];
      return data.map((json) => MovieWatchHistory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movie watch histories');
    }
  }

  Future<void> addMovieWatchHistory(int tmdbId, String userId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
      body: json.encode({'tmdbId': tmdbId, 'userId': userId}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add movie watch history');
    }
  }

  Future<void> deleteMovieWatchHistory(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete movie watch history');
    }
  }

  Future<bool> isMovieWatched(int tmdbId, String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/$tmdbId/$userId'));
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Failed to check if movie is watched');
    }
  }
}
