import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../uikit/widgets/top_bar.dart'; // TopBar import 추가
import 'settings_screen.dart'; // SettingsScreen import 추가

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // 배경색 설정
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 사진, 닉네임, 이메일 표시
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage('https://via.placeholder.com/80'), // Placeholder 이미지
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '닉네임',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textWhite, // 텍스트 색상을 흰색으로 설정
                      ),
                    ),
                    Text(
                      'email@example.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textWhite, // 텍스트 색상을 흰색으로 설정
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.favorite, color: AppColors.textWhite), // 아이콘 색상을 흰색으로 설정
                    title: Text('관심목록', style: TextStyle(color: AppColors.textWhite)), // 텍스트 색상을 흰색으로 설정
                    onTap: () {
                      // 관심목록 페이지로 이동
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.history, color: AppColors.textWhite), // 아이콘 색상을 흰색으로 설정
                    title: Text('시청기록', style: TextStyle(color: AppColors.textWhite)), // 텍스트 색상을 흰색으로 설정
                    onTap: () {
                      // 시청기록 페이지로 이동
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.rate_review, color: AppColors.textWhite), // 아이콘 색상을 흰색으로 설정
                    title: Text('리뷰 평가 관리', style: TextStyle(color: AppColors.textWhite)), // 텍스트 색상을 흰색으로 설정
                    onTap: () {
                      // 리뷰 평가 관리 페이지로 이동
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: AppColors.textWhite), // 아이콘 색상을 흰색으로 설정
                    title: Text('설정', style: TextStyle(color: AppColors.textWhite)), // 텍스트 색상을 흰색으로 설정
                    onTap: () {
                      // SettingScreen으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsScreen()), // 설정 화면으로 이동
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
