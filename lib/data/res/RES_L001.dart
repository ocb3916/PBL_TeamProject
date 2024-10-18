/**
 * @Author 김윤정
 * @since 2024.10.18
 *
 * 로그인 응답 DTO(응답 데이터)
 *
 */
class RES_L001 {
  final String nickname; //닉네임
  final String email; //이메일
  final String birth; //생일
  final String male; //성별
  final String imagePath; //imageUrl

  RES_L001(this.nickname, this.email, this.birth, this.male, this.imagePath);
}