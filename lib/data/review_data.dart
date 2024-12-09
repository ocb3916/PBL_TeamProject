import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/review_model.dart';

class MovieReviewData {
  final String baseUrl = 'https://contentspick.site/api/movie-reviews';

  Future<List<MovieReview>> fetchAllReviews() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => MovieReview.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load all reviews');
    }
  }

  Future<MovieReview> fetchReviewById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return MovieReview.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load review by ID');
    }
  }

  Future<List<MovieReview>> fetchReviewsForMovie(int tmdbId) async {
    final response = await http.get(Uri.parse('$baseUrl/tmdb/$tmdbId'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => MovieReview.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews for movie');
    }
  }


  Future<List<MovieReview>> fetchReviewsForUser(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => MovieReview.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user reviews');
    }
  }

  Future<List<MovieReview>> fetchReviewsByRating(int rating) async {
    final response = await http.get(Uri.parse('$baseUrl/rating/$rating'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => MovieReview.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews by rating');
    }
  }

  Future<List<MovieReview>> fetchReviewsSortedUpvotes() async {
    final response = await http.get(Uri.parse('$baseUrl/sorted/upvotes'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => MovieReview.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews by upvotes');
    }
  }


  Future<MovieReview?> createOrUpdateReview(MovieReview movieReview) async {
    final jsonBody = json.encode(movieReview.toJson());
    print('Sending JSON: $jsonBody');  // JSON 데이터를 로깅하여 확인

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return MovieReview.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to create or update review');
    }
  }


  Future<void> deleteReview(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete review');
    }
  }
  Future<List<MovieReview>> fetchReviewsByNickname(String nickname) async {
    final response = await http.get(Uri.parse('$baseUrl/nickname/$nickname'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => MovieReview.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews by nickname');
    }
  }


}
