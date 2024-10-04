import 'package:flutter/material.dart';
import 'package:untitled1/screens/sign_up_screen.dart';
import 'main_screen.dart'; // MainScreen import 추가

class LoginScreen extends StatelessWidget {
  final Function(bool) loginCallback; // 콜백 함수 추가

  // 생성자에서 콜백을 받습니다.
  LoginScreen({required this.loginCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('로그인'),
    ),
    body: Center(
    child: Padding(
    padding: const EdgeInsets.all(15.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text('로그인', style: TextStyle(fontSize: 24)),
    SizedBox(height: 20),
    TextField(
    decoration: InputDecoration(
    labelText: '이메일',
    border: OutlineInputBorder(),
    ),
    ),
    TextField(
    decoration: InputDecoration(
    labelText: '비밀번호',
    border: OutlineInputBorder(),
    ),
    obscureText: true,
    ),
    SizedBox(height: 20),
    ElevatedButton(
    onPressed: () {
    // 로그인 성공 시
    loginCallback(true); // 로그인 상태를 true로 설정
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => MainScreen()), // MainScreen으로 이동
    );
    },
    child: Text('로그인'),
    ),
      SizedBox(height: 10),
      TextButton(
        onPressed: () {
          // 회원가입 페이지로 이동할 코드 추가
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUpScreen()), // 회원가입 페이지로 이동
          );
        },
        child: Text('아직 계정이 없으신가요? 회원가입'),
      ),
    ],
    ),
    ),
    ),
    );
  }
}
