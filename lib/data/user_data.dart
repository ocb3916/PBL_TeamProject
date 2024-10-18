import 'dart:convert';
import 'package:untitled1/data/res/RES_L001.dart';
import 'package:untitled1/model/movie_model.dart';
import 'package:http/http.dart' as http;

import '../uiState/profile/User.dart';

class UserData {
  // TODO 백엔드 서버  로그인 API domain으로 변경
  final String baseUrl ='https://api.themoviedb.org/3/movie';

  //TODO 로그인 메소드
  Future<User> login(REQ) async {
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
      return User(resL001.nickname, resL001.email, resL001.birth, resL001.male, resL001.imagePath);
    } else {
      throw Exception("Failed to load movie data");
    }
  }


}
