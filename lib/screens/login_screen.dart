import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth 임포트
import '../constants/colors.dart';
import '../screens/sign_up_screen.dart';
import '../uikit/widgets/sub_title.dart';
import '../uikit/widgets/top_bar.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
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
    controller: emailController,
    decoration: InputDecoration(
    filled: true,
    fillColor: AppColors.cardBackground,
    hintText: '이메일',
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
    // 로그인 함수 호출
    User? user = await loginUser(emailController.text, passwordController.text);
    if (user != null) {
    print("로그인 성공: ${user.email}");
    // 성공 후 홈 화면으로 이동 등 추가 작업 수행
    } else {
    print("로그인 실패");
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
    // 비밀번호 찾기 로직 추가
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

  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 로그인 성공시, 해당 유저 객체 반환
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Error logging in: ${e.message}");
      return null;
    }
  }
}
