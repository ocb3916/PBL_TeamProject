import 'package:flutter/material.dart';
import '../uikit/widgets/top_bar.dart'; // TopBar import
import '../uikit/widgets/sub_title.dart'; // SubTitle import
import '../constants/colors.dart'; // AppColors import

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(), // TopBar 사용
      body: Container(
        color: AppColors.background, // 배경 색상 설정
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubTitle(title: '계정 연동 설정'),
            SwitchListTile(
              title: Text('카카오 연동', style: TextStyle(color: AppColors.textWhite)), // 텍스트 색상 변경
              value: true, // 기본값 예시
              activeColor: AppColors.textWhite, // 선택 시 색상
              onChanged: (bool value) {
                // 카카오 연동 상태 변경 로직
              },
            ),
            SwitchListTile(
              title: Text('네이버 연동', style: TextStyle(color: AppColors.textWhite)), // 텍스트 색상 변경
              value: false, // 기본값 예시
              activeColor: AppColors.textWhite, // 선택 시 색상
              onChanged: (bool value) {
                // 네이버 연동 상태 변경 로직
              },
            ),
            Divider(color: AppColors.textWhite), // 구분선 색상 변경
            SubTitle(title: '고객센터'), // 텍스트 색상 변경
            ListTile(
              title: Text('문의하기/FAQ', style: TextStyle(color: AppColors.textWhite)), // 텍스트 색상 변경
              onTap: () {
                // 고객센터 문의하기 화면으로 이동
              },
              trailing: Icon(Icons.keyboard_arrow_right, color: AppColors.textWhite), // 아이콘 색상 변경
            ),
            ListTile(
              title: Text('공지사항', style: TextStyle(color: AppColors.textWhite)), // 텍스트 색상 변경
              onTap: () {
                // 공지사항 화면으로 이동
              },
              trailing: Icon(Icons.keyboard_arrow_right, color: AppColors.textWhite), // 아이콘 색상 변경
            ),
            Divider(color: AppColors.textWhite), // 두 번째 구분선 색상 변경
            ListTile(
              title: Text('로그아웃', style: TextStyle(color: AppColors.textWhite)), // 텍스트 색상 변경
              onTap: () {
                // 로그아웃 처리 로직
              },
              trailing: Icon(Icons.exit_to_app, color: AppColors.textWhite), // 아이콘 색상 변경
            ),
            ListTile(
              title: Text('계정 삭제', style: TextStyle(color: AppColors.textWhite)), // 텍스트 색상 변경
              onTap: () {
                // 계정 삭제 처리 로직
              },
              trailing: Icon(Icons.delete_forever, color: AppColors.textWhite), // 아이콘 색상 변경
            ),
          ],
        ),
      ),
    );
  }
}
