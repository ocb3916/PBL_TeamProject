class CastModel {
  final String name;
  final String profilePath;
  final String character;

  CastModel({
    required this.name,
    required this.profilePath,
    required this.character,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      name: json['name'] ?? '',
      profilePath: json['profile_path'] ?? '',
      character: json['character'] ?? '',
    );
  }
}
