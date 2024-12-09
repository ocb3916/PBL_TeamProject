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


  //TODO 로그인 메소드
  /*Future<User> login(REQ_L001 reqL001) async {
    //final String baseUrl ='https://api.themoviedb.org/3/movie';

    final response = await http.get(
      // TODO 백엔드 서버  로그인 API path(uri)로 변경
      //url, domain, path(uri) 차이점
      //url은 uri를 포함하는 개념 http://..... 부터 전부다 지칭하는 표현
      //domain은 http://www.naver.com 처럼 앞부분
      //uri는 http://www.naver.com/maps 에서 뒤에붙는 /maps 부터를 지칭
        Uri.parse('http://localhost:8080/api/json'),
        headers: {
          'accept': 'application/json',
        },
        body: json.encode({
          'id': reqL001.id,
          'pw': reqL001.pw,
          'email': reqL001.email,
          'birthDate': reqL001.birthDate,
          'gender': reqL001.gender,
          'name': reqL001.name,
          'nickName': reqL001.nickName,
          'phoneNumber': reqL001.phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      final user = User(
        id: reqL001.id,
        nickname: reqL001.nickName,
        email: reqL001.email,
        birthDate: reqL001.birthDate,
        gender: reqL001.gender,
        name: reqL001.name,
        phoneNumber: reqL001.phoneNumber,
        password: reqL001.pw, // 평문 사용 주의
      );

      SharePrefManager.pref.setString(SharedPrefConst.USER_ID, reqL001.id); // 로그인 정보 저장
      return user;
    } else {
      throw Exception("로그인 실패: ${response.body}");
    }
  }
}
    //성공응답
    if (response.statusCode == 200) {
      RES_L001 resL001 = jsonDecode(response.body);
      SharePrefManager.pref.setString(SharedPrefConst.USER_ID, reqL001.id);
      // 여러개의 쿠키들을 분리해주는 Regex
      var exp = RegExp(r'((?:[^,]|, )+)');
      Iterable<RegExpMatch> matches = exp.allMatches(response.headers["set-cookie"]!);
      for (final m in matches) {
        // 쿠키 한개에 대한 디코딩 처리
        Cookie cookie = Cookie.fromSetCookieValue(m[0]!);
        print('[set-cookie] name: ${cookie.name}, value: ${cookie
            .value}, expires: ${cookie.expires}, maxAge: ${cookie
            .maxAge}, secure: ${cookie.secure}, httpOnly: ${cookie.httpOnly}');

        // TODO 위의 COOKIE 객체에서 SharedPref에 cookie 저장 후 로그인 이 필요한 API를 쏠때마다 Sharedpref에서 쿠키가져와서 헤더에 넣어줘야함
      }
      return User(resL001.nickname, resL001.email, resL001.birth, resL001.male, resL001.imagePath);
    } else {
      throw Exception("Failed to load movie data");
    }
  }
}*/