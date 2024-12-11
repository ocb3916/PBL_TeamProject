import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/colors.dart';
import '../../uikit/widgets/top_bar.dart';
import 'password_reset_step2.dart';

class PasswordResetStep1 extends StatelessWidget {
  final idController = TextEditingController();
  final nameController = TextEditingController();

  Future<void> sendVerificationCode(BuildContext context) async {
    if (idController.text.isEmpty || nameController.text.isEmpty) {
      final snackBar = SnackBar(
        content: Text('ID와 이름을 입력해 주세요.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://contentspick.site/api/users/user-authentication'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({
          'id': idController.text,
          'name': nameController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordResetStep2(
              id: idController.text,
            ),
          ),
        );
      } else {
        final snackBar = SnackBar(
          content: Text('일치하는 아이디가 없습니다.'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
            TextField(
              controller: idController,
              decoration: InputDecoration(
                hintText: '사용자 ID',
                filled: true,
                fillColor: AppColors.cardBackground,
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
              controller: nameController,
              decoration: InputDecoration(
                hintText: '이름',
                filled: true,
                fillColor: AppColors.cardBackground,
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
              onPressed: () => sendVerificationCode(context),
              child: Text('인증번호 보내기'),
            ),
          ],
        ),
      ),
    );
  }
}
