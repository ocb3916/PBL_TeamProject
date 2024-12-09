class User {
  final String id; // 사용자 ID
  final String nickname;
  final String email;
  final String birthDate; // 문자열 형식으로 변경
  final String gender; // 'FEMALE' 또는 'MALE'
  final String name;
  final String phoneNumber;
  final String password;

  User({
    required this.id,
    required this.nickname,
    required this.email,
    required this.birthDate,
    required this.gender,
    required this.name,
    required this.phoneNumber,
    required this.password,
  });
}
