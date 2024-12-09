import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/colors.dart';
import '../uikit/widgets/sub_title.dart';
import '../uikit/widgets/top_bar.dart';
import '../data/req/REQ_L001.dart';
import '../data/user_data.dart';
import '../screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final idController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final nicknameController = TextEditingController();
  final genderController = TextEditingController();
  final phoneNumberController = TextEditingController();

  bool isIdChecked = false;

  Future<void> checkIdDuplicate(BuildContext context) async {
    UserData userData = UserData();
    try {
      bool isAvailable = await userData.checkIdDuplicate(idController.text);
      if (isAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사용 가능한 아이디입니다.')),
        );
        setState(() {
          isIdChecked = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미 사용 중인 아이디입니다. 다른 아이디를 입력해주세요.')),
        );
        setState(() {
          isIdChecked = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('아이디 중복 체크 중 오류가 발생했습니다. 다시 시도해주세요.')),
      );
    }
  }

  void registerUser() async {
    if (!isIdChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('아이디 중복 확인을 해주세요.')),
      );
      return;
    }

    REQ_L001 reqL001 = REQ_L001(
      id: idController.text,
      pw: passwordController.text,
      birthDate: dobController.text,
      email: emailController.text,
      gender: genderController.text.toUpperCase(),
      name: nameController.text,
      nickName: nicknameController.text,
      phoneNumber: phoneNumberController.text,
    );

    try {
      final response = await http.post(
        Uri.parse('https://contentspick.site/api/users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': reqL001.id,
          'pw': reqL001.pw,
          'email': reqL001.email,
          'birthDate': reqL001.birthDate,
          'gender': reqL001.gender,
          'name': reqL001.name,
          'nickName': reqL001.nickName,
          'phoneNumber': reqL001.phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        print("회원가입 성공");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        print("회원가입 실패: ${response.body}");
      }
    } catch (e) {
      print("오류: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: TopBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SubTitle(title: '회원가입'),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: idController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.cardBackground,
                        hintText: '사용자 ID',
                        hintStyle: TextStyle(color: AppColors.textGray),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: AppColors.textWhite),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => checkIdDuplicate(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardBackground,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      '중복 확인',
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
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
              TextField(
                controller: genderController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  hintText: '성별 (male/female)',
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
                controller: phoneNumberController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  hintText: '전화번호',
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
                onPressed: registerUser,
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
      ),
    );
  }
}
