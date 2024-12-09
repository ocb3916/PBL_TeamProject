class MovieWatchHistory {
  final int id;
  final int tmdbId;
  final String userId;

  MovieWatchHistory({required this.id, required this.tmdbId, required this.userId});

  factory MovieWatchHistory.fromJson(Map<String, dynamic> json) {
    return MovieWatchHistory(
      id: json['id'] ?? 0, // 기본값 설정
      tmdbId: json['tmdbId'] ?? 0, // 기본값 설정
      userId: json['user']['id'] ?? 'unknown_user', // 기본값 설정
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
