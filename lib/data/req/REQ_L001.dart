/**
 * @Author 김윤정
 * @since 2024.10.18
 *
 * 로그인 요청 DTO(요청 데이터)
 */
class REQ_L001 {
  final String id; // 사용자 ID
  final String pw; // 비밀번호
  final String birthDate; // 생년월일
  final String email; // 이메일
  final String gender; // 성별
  final String name; // 이름
  final String nickName; // 닉네임
  final String phoneNumber; // 전화번호

  REQ_L001({
    required this.id,
    required this.pw,
    required this.birthDate,
    required this.email,
    required this.gender,
    required this.name,
    required this.nickName,
    required this.phoneNumber,
  });
}
