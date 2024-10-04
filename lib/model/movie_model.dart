class MovieModel {
  final bool adult;
  final String backdropPath;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final String releaseDate;
  final String title;
  final double voteAverage;
  final int voteCount;
  final List<int> genreIds; // 장르 ID 리스트 추가

  MovieModel({
    required this.adult,
    required this.backdropPath,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds, // 장르 ID 리스트를 생성자에 추가
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      adult: json['adult'] ?? false,
      backdropPath: json['backdrop_path'] ?? "",
      id: json['id'] ?? 0,
      originalLanguage: json['original_language'] ?? "",
      originalTitle: json['original_title'] ?? "",
      overview: json['overview'] ?? "",
      popularity: json['popularity']?.toDouble() ?? 0.0,
      posterPath: json['poster_path'] ?? "",
      releaseDate: json['release_date'] ?? "",
      title: json['title'] ?? "",
      voteAverage: json['vote_average']?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] ?? 0,
      genreIds: List<int>.from(json['genre_ids'] ?? []), // 장르 ID를 리스트로 변환
    );
  }
}
