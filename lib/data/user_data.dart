import 'dart:convert';
import 'package:http/http.dart' as http;
import '../SharedPreference.dart';
import '../uiState/profile/User.dart';
import '../data/req/REQ_L001.dart';

class UserData {
  final String baseUrl = 'https://contentspick.site/api/users';

  Future<User> login(REQ_L001 reqL001) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
      },
      body: json.encode({
        'id': reqL001.id,
        'pw': reqL001.pw,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return User(
        id: data['id'],
        nickname: data['nickName'],
        email: data['email'],
        birthDate: data['birthDate'],
        gender: data['gender'],
        name: data['name'],
        phoneNumber: data['phoneNumber'],
        password: reqL001.pw,
      );
    } else {
      throw Exception("로그인 실패: ${response.body}");
    }
  }

  Future<void> logout(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'userId': userId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("로그아웃 실패: ${response.body}");
    }
  }

  Future<void> deleteAccount(String userId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$userId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 204) {
      throw Exception("계정 삭제 실패: ${response.body}");
    }
  }

  Future<bool> checkIdDuplicate(String id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/check-id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
      },
      body: json.encode({'id': id}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return data['available'];
    } else {
      throw Exception("아이디 중복 체크 실패: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$userId'),
    );

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception("프로필 조회 실패: ${response.body}");
    }
  }

  Future<void> updateEmail(String userId, String newEmail) async {
    final response = await http.put(
      Uri.parse('$baseUrl/email'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({'userId': userId, 'value': newEmail}),
    );

    if (response.statusCode != 200) {
      throw Exception("이메일 업데이트 실패: ${response.body}");
    }
  }

  Future<void> updateNickname(String userId, String newNickname) async {
    final response = await http.put(
      Uri.parse('$baseUrl/nickname'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({'userId': userId, 'value': newNickname}),
    );

    if (response.statusCode != 200) {
      throw Exception("닉네임 업데이트 실패: ${response.body}");
    }
  }

  Future<void> resendVerificationCode(String id, String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/resend-code'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'id': id,
        'name': name,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("인증번호 재전송 실패: ${response.body}");
    }
  }
}

