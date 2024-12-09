import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../constants/colors.dart';
import '../../uikit/widgets/top_bar.dart';
import '../login_screen.dart';

class PasswordResetStep3 extends StatelessWidget {
  final String userId;
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  PasswordResetStep3({required this.userId});

  Future<void> resetPassword(BuildContext context) async {
    if (passwordController.text != confirmPasswordController.text) {
      final snackBar = SnackBar(
        content: Text('비밀번호가 일치하지 않습니다. 다시 입력해주세요.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://contentspick.site/api/users/reset-password'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({
          'userId': userId,
          'newPassword': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        final snackBar = SnackBar(
          content: Text('비밀번호 변경에 실패했습니다. 다시 시도해주세요.'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print("Error: ${response.body}");
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Text('오류가 발생했습니다. 다시 시도해주세요.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print("Error: $e");
    }
  }

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
            Text(
              '사용자 ID: $userId',
              style: TextStyle(color: AppColors.textWhite, fontSize: 18),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: '새 비밀번호',
                filled: true,
                fillColor: AppColors.cardBackground,
                hintStyle: TextStyle(color: AppColors.textGray),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: true,
              style: TextStyle(color: AppColors.textWhite),
            ),
            SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                hintText: '비밀번호 재입력',
                filled: true,
                fillColor: AppColors.cardBackground,
                hintStyle: TextStyle(color: AppColors.textGray),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: true,
              style: TextStyle(color: AppColors.textWhite),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => resetPassword(context),
              child: Text('비밀번호 변경'),
            ),
          ],
        ),
      ),
    );
  }
}
