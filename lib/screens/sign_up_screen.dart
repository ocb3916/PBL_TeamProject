import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore 임포트
import '../constants/colors.dart';
import '../uikit/widgets/sub_title.dart';
import '../uikit/widgets/top_bar.dart';

class SignUpScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final dobController = TextEditingController(); // 생년월일 입력
  final nicknameController = TextEditingController();
  final genderController = TextEditingController(); // 성별 입력

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
    SubTitle(title: '회원가입'),
    SizedBox(height: 16),
    TextField(
    controller: emailController,
    decoration: InputDecoration(
    filled: true,
    fillColor: AppColors.cardBackground,
    hintText: '이메일 주소',
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
    obscureText: true,
    style: TextStyle(color: AppColors.textWhite),
    ),
    SizedBox(height: 16),
    TextField(
    controller: nameController,
    decoration: InputDecoration(
    filled: true,
    fillColor: AppColors.cardBackground,
    hintText: '이름',
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
    controller: dobController,
    decoration: InputDecoration(
    filled: true,
    fillColor: AppColors.cardBackground,
    hintText: '생년월일 (YYYY-MM-DD)',
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
    controller: nicknameController,
    decoration: InputDecoration(
    filled: true,
    fillColor: AppColors.cardBackground,
    hintText: '닉네임',
    hintStyle: TextStyle(color: AppColors.textGray),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide.none,
    ),
    ),
    style: TextStyle(color: AppColors.textWhite),
    ),
    SizedBox(height: 16),
    // 성별 입력 필드 추가
    TextField(
    controller: genderController,
    decoration: InputDecoration(
    filled: true,
    fillColor: AppColors.cardBackground,
    hintText: '성별 (남/여)',
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
    // 회원가입 로직을 여기서 구현합니다.
    await registerUser(
    emailController.text,
    passwordController.text,
    nameController.text,
    DateTime.parse(dobController.text), // 생년월일 변환
    nicknameController.text,
    genderController.text,
    );
    },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.cardBackground,
        padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        '회원가입',
        style: TextStyle(
          color: AppColors.textWhite,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    ],
    ),
    ),
    );
  }

  Future<void> registerUser(String email, String password, String name, DateTime dateOfBirth, String nickname, String gender) async {
    try {
      // Firebase Authentication을 통해 사용자 등록
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Firestore에 추가 정보 저장
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'name': name,
        'dateOfBirth': dateOfBirth,
        'nickname': nickname,
        'gender': gender, // 성별 필드 추가
      });

      print("User registered successfully!");
    } on FirebaseAuthException catch (e) {
      print("Error registering user: ${e.message}");
    } catch (e) {
      print("Error: $e");
    }
  }
}
