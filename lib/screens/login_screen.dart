import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/screens/password/password_reset_step1.dart';
import 'dart:convert';
import '../SharedPreference.dart';
import '../constants/colors.dart';
import '../screens/sign_up_screen.dart';
import '../uikit/widgets/sub_title.dart';
import '../uikit/widgets/top_bar.dart';
import '../screens/profile_screen.dart'; // 마이페이지로 이동하기 위한 import 추가

class LoginScreen extends StatelessWidget {
  final idController = TextEditingController(); // 사용자 ID 입력
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: TopBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SubTitle(title: '로그인'),
            SizedBox(height: 16),
            TextField(
              controller: idController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.cardBackground,
                hintText: '아이디',
                hintStyle: TextStyle(color: AppColors.textGray),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: AppColors.textWhite),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.cardBackground,
                hintText: '비밀번호',
                hintStyle: TextStyle(color: AppColors.textGray),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: AppColors.textWhite),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // ID와 비밀번호를 사용하여 로그인
                final user = await loginUser(
                    idController.text, passwordController.text); // ID와 비밀번호 전송

                if (user != null) {
                  print("로그인 성공: ${user['nickName']}");
                  await SharePrefManager.saveUserId(user['id']);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()), // 로그인 후 마이페이지로 이동
                  );
                } else {
                  // 로그인 실패 시 경고창 띄우기
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('로그인 실패'),
                        content: Text('아이디와 비밀번호를 다시 확인해 주세요.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cardBackground,
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '로그인',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordResetStep1()),
                );
              },
              child: Text(
                '비밀번호 찾기',
                style: TextStyle(color: AppColors.textGray),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text(
                '계정이 없으신가요? 회원가입',
                style: TextStyle(color: AppColors.textGray),
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(child: Divider(color: AppColors.textGray)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("or", style: TextStyle(color: AppColors.textGray)),
                ),
                Expanded(child: Divider(color: AppColors.textGray)),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 소셜 로그인 버튼 추가 가능 (예: 카카오, 네이버)
                SizedBox(width: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> loginUser(String id, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://contentspick.site/api/users/login'), // 로그인 API URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': id, // 사용자가 입력한 ID
          'pw': password, // 사용자가 입력한 비밀번호
        }),
      );

      if (response.statusCode == 200) {
        // 로그인 성공 시 사용자 정보 반환
        return json.decode(response.body);
      } else {
        print("Error logging in: ${response.body}");
        return null; // 로그인 실패 시 null 반환
      }
    } catch (e) {
      print("Error: $e");
      return null; // 예외 처리
    }
  }
}
