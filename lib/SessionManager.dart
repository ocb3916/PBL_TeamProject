import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/data/req/REQ_L001.dart';
import 'package:untitled1/uiState/profile/User.dart';
import 'package:http/http.dart' as http;

import 'SharedPreference.dart';
import 'data/res/RES_L001.dart';



class Sessionmanager {
  static bool isLogin()  {
    if(SharePrefManager.pref.getString(SharedPrefConst.USER_ID) != null) {
      return true;
    } else {
      return false;
    }
  }

  //TODO 로그인 메소드
  Future<User> login(REQ_L001 reqL001) async {
    final String baseUrl ='https://api.themoviedb.org/3/movie';

    final response = await http.get(
      // TODO 백엔드 서버  로그인 API path(uri)로 변경
      //url, domain, path(uri) 차이점
      //url은 uri를 포함하는 개념 http://..... 부터 전부다 지칭하는 표현
      //domain은 http://www.naver.com 처럼 앞부분
      //uri는 http://www.naver.com/maps 에서 뒤에붙는 /maps 부터를 지칭
        Uri.parse('$baseUrl/now_playing?language=ko-KR&page=1'),
        headers: {
          'accept': 'application/json',
        }
    );

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
}