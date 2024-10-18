import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefConst {
  static const String USER_ID = "user_id";
}

class SharePrefManager {
  static late SharedPreferences pref;

  static Future<void> init() async {
    pref = await SharedPreferences.getInstance(); // 초기화
  }
}
