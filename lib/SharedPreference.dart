import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefConst {
  static const String USER_ID = "user_id";
  static const String USER_NICKNAME = "user_nickname";
}

class SharePrefManager {
  static late SharedPreferences pref;

  static Future<void> init() async {
    pref = await SharedPreferences.getInstance(); // 초기화
  }

  static Future<void> saveUserId(String userId) async {
    await pref.setString(SharedPrefConst.USER_ID, userId);
  }

  // 사용자 ID 가져오기
  static String? getUserId() {
    return pref.getString(SharedPrefConst.USER_ID);
  }

  // 사용자 닉네임 가져오기
  static String? getUserNickname() {
    return pref.getString(SharedPrefConst.USER_NICKNAME);
  }

  // 사용자 ID 삭제
  static Future<void> removeUserId() async {
    await pref.remove(SharedPrefConst.USER_ID);
  }

  // 로그인 상태 체크
  static bool isLoggedIn() {
    return pref.getString(SharedPrefConst.USER_ID) != null;
  }

  // SharePreferences 초기화 확인
  static bool isInitialized() {
    return pref != null;
  }
}
