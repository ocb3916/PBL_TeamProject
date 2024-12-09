import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../uikit/widgets/top_bar.dart';
import '../data/user_data.dart'; // UserData import 추가

class EditProfileScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String nickName;

  EditProfileScreen({required this.userId, required this.email, required this.nickName});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final emailController = TextEditingController();
  final nickNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
    nickNameController.text = widget.nickName;
  }

  Future<void> updateProfile() async {
    final userId = widget.userId;
    UserData userData = UserData();

    try {
      // 이메일 업데이트
      await userData.updateEmail(userId, emailController.text);

      // 닉네임 업데이트
      await userData.updateNickname(userId, nickNameController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필이 성공적으로 업데이트되었습니다.')),
      );
      Navigator.pop(context, {'email': emailController.text, 'nickName': nickNameController.text});
    } catch (e) {
      print("프로필 업데이트 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필 업데이트 실패. 다시 시도해주세요.')),
      );
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              controller: nickNameController,
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
            ElevatedButton(
              onPressed: updateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cardBackground,
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '프로필 업데이트',
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
}
