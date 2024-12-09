import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/favorite_movie_model.dart';

class FavoriteMovieData {
  final String baseUrl = 'https://contentspick.site/api/movie-favorite-lists';


  Future<List<FavoriteMovie>> fetchFavoriteMovies(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => FavoriteMovie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load favorite movies');
    }
  }

  Future<void> addFavoriteMovie(int tmdbId, String userId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
      body: json.encode({'tmdbId': tmdbId, 'userId': userId}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add favorite movie');
    }
  }

  Future<void> deleteFavoriteMovie(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete favorite movie');
    }
  }

  Future<bool> isFavoriteMovie(int tmdbId, String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/$tmdbId/$userId'));
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Failed to check if movie is favorite');
    }
  }


}
