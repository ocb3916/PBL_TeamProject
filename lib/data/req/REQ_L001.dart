/**
 * @Author 김윤정
 * @since 2024.10.18
 *
 * 로그인 요청 DTO(요청 데이터)
 */
class REQ_L001 {
  final String id; //아이디
  final String pwd; //비밀번호 원래는 암호화 된걸로 넣어야함

  REQ_L001({required this.id, required this.pwd});
}