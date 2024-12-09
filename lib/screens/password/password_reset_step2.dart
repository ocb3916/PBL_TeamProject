import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/screens/password/password_reset_step3.dart';
import 'dart:convert';
import '../../constants/colors.dart';
import '../../uikit/widgets/top_bar.dart';

class PasswordResetStep2 extends StatefulWidget {
  final String id;
  final String name;

  PasswordResetStep2({required this.id, required this.name});

  @override
  _PasswordResetStep2State createState() => _PasswordResetStep2State();
}

class _PasswordResetStep2State extends State<PasswordResetStep2> {
  final codeController = TextEditingController();

  Future<void> verifyCode(BuildContext context) async {
    if (codeController.text.isEmpty) {
      final snackBar = SnackBar(
        content: Text('인증번호를 입력해 주세요.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final requestData = {
      'userId': widget.id,
      'code': codeController.text,
    };

    print('Sending request data: $requestData');

    try {
      final response = await http.post(
        Uri.parse('https://contentspick.site/verification/verify'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(requestData),
      );

      print('Server response: ${response.body}');

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PasswordResetStep3(userId: widget.id)),
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

  Future<void> resendCode(BuildContext context) async {
    if (widget.id.isEmpty || widget.name.isEmpty) {
      final snackBar = SnackBar(
        content: Text('ID와 이름을 입력해 주세요.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final requestData = {
      'userId': widget.id,
      'name': widget.name,
    };

    print('Sending request data: $requestData');

    try {
      final response = await http.post(
        Uri.parse('https://contentspick.site/api/users/resend-code'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(requestData),
      );

      print('Server response: ${response.body}');

      if (response.statusCode == 200) {
        final snackBar = SnackBar(
          content: Text('인증번호가 다시 전송되었습니다.'),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(
          content: Text('인증번호 전송에 실패했습니다. 다시 시도해주세요.'),
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
            SizedBox(height: 16),
            TextButton(
              onPressed: () => resendCode(context),
              child: Text('인증번호를 못 받으셨습니까? 다시 요청하기', style: TextStyle(color: AppColors.textWhite)),
            ),
          ],
        ),
      ),
    );
  }
}
