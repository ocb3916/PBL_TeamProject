import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/data/req/REQ_L001.dart';
import 'package:untitled1/uiState/profile/User.dart';
import 'package:http/http.dart' as http;

import 'SharedPreference.dart';
import 'data/res/RES_L001.dart';
import 'data/user_data.dart';

class SessionManager {
  final UserData _userData = UserData();

  static bool isLogin() {
    return SharePrefManager.pref.getString(SharedPrefConst.USER_ID) != null;
  }

  Future<User> login(REQ_L001 reqL001) async {
    final user = await _userData.login(reqL001);
    SharePrefManager.pref.setString(SharedPrefConst.USER_ID, reqL001.id);
    return user;
  }

  Future<void> logout() async {
    final userId = SharePrefManager.pref.getString(SharedPrefConst.USER_ID);
    if (userId != null) {
      await _userData.logout(userId);
    }
    await SharePrefManager.removeUserId();
  }
    Future<void> deleteAccount() async {
      final userId = SharePrefManager.pref.getString(SharedPrefConst.USER_ID);
      if (userId != null) {
        try {
          await _userData.deleteAccount(userId);
          await logout(); // 계정 삭제 후 로그아웃 처리
        } catch (e) {
          throw Exception("계정 삭제 실패: $e");
        }
      } else {
        throw Exception("로그인된 사용자가 없습니다.");
      }
    }

  // 현재 로그인된 사용자 정보 가져오기
  Future<User?> getCurrentUser() async {
    final userId = SharePrefManager.getUserId();
    if (userId != null) {
      final response = await http.get(
        Uri.parse('https://contentspick.site/api/users/$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User(
          id: data['id'],
          nickname: data['nickName'],
          email: data['email'],
          birthDate: data['birthDate'],
          gender: data['gender'],
          name: data['name'],
          phoneNumber: data['phoneNumber'],
          password: '', // 비밀번호는 포함하지 않음
        );
      } else {
        throw Exception('Failed to load user profile');
      }
    }
    return null;
  }



  // 세션 갱신 (필요한 경우)
  Future<void> refreshSession() async {
    // 토큰 기반 인증을 사용하는 경우, 여기서 토큰을 갱신할 수 있습니다.
    throw UnimplementedError("세션 갱신 기능이 구현되지 않았습니다.");
  }
}


