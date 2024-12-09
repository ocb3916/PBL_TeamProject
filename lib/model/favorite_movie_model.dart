class FavoriteMovie {
  final int id;
  final int tmdbId;
  final String userId;

  FavoriteMovie({required this.id, required this.tmdbId, required this.userId});

  factory FavoriteMovie.fromJson(Map<String, dynamic> json) {
    return FavoriteMovie(
      id: json['id'] ?? 0,
      tmdbId: json['tmdbId'] ?? 0,
      userId: json['userId'] ?? 'unknown_user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tmdbId': tmdbId,
      'userId': userId,
    };
  }
}
