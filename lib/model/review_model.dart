class MovieReview {
  final int id;
  final String userId;
  final String nickname;
  final String review;
  final int rating;
  final int upvotes;
  final int downvotes;
  final DateTime reviewDate;
  final String reviewTitle;
  final int tmdbId;

  MovieReview({
    required this.id,
    required this.userId,
    required this.nickname,
    required this.review,
    required this.rating,
    required this.upvotes,
    required this.downvotes,
    required this.reviewDate,
    required this.reviewTitle,
    required this.tmdbId,
  });

  factory MovieReview.fromJson(Map<String, dynamic> json) {
    return MovieReview(
      id: json['id'] as int,
      userId: json['userId'] as String? ?? 'unknown_user',
      nickname: json['nickname'] ?? 'unknown_nickname',
      review: json['review'] ?? '',
      rating: json['rating'] as int? ?? 0,
      upvotes: json['upvotes'] as int? ?? 0,
      downvotes: json['downvotes'] as int? ?? 0,
      reviewDate: DateTime.parse(json['reviewDate'] ?? DateTime.now().toIso8601String()),
      reviewTitle: json['reviewTitle'] ?? '',
      tmdbId: json['tmdbId'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'nickname': nickname,
      'review': review,
      'rating': rating,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'reviewDate': reviewDate.toIso8601String(),
      'reviewTitle': reviewTitle,
      'tmdbId': tmdbId,
    };
  }
}
