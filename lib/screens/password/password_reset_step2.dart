import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/colors.dart';
import '../../uikit/widgets/top_bar.dart';
import 'password_reset_step3.dart';

class PasswordResetStep2 extends StatelessWidget {
  final String id;
  final codeController = TextEditingController();

  PasswordResetStep2({required this.id});

  Future<void> verifyCode(BuildContext context) async {
    if (codeController.text.isEmpty) {
      final snackBar = SnackBar(
        content: Text('인증번호를 입력해 주세요.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://contentspick.site/verification/verify'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({
          'userId': id,
          'code': codeController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PasswordResetStep3(userId: id)),
        );
      } else {
        final snackBar = SnackBar(
          content: Text('인증번호가 틀렸습니다. 다시 입력해주세요.'),
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
              controller: codeController,
              decoration: InputDecoration(
                hintText: '인증번호',
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
              onPressed: () => verifyCode(context),
              child: Text('인증번호 확인'),
            ),
          ],
        ),
      ),
    );
  }
}
