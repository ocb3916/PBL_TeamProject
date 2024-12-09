import 'package:flutter/material.dart';
import '../SharedPreference.dart';
import '../data/user_data.dart';
import '../uikit/widgets/top_bar.dart'; // TopBar import
import '../uikit/widgets/sub_title.dart'; // SubTitle import
import '../constants/colors.dart'; // AppColors import
import 'package:http/http.dart' as http;
import 'package:untitled1/SessionManager.dart';

import 'inquiry_screen.dart';
import 'notices_screen.dart';

class SettingsScreen extends StatelessWidget {
  final SessionManager sessionManager = SessionManager(); // 세션 매니저 객체

  Future<void> logout(BuildContext context) async {
    try {
      await sessionManager.logout();
      // 로그아웃 성공 후 홈 화면으로 이동
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print("로그아웃 실패: $e");
      // 에러 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그아웃 실패. 다시 시도하세요.')),
      );
    }
  }
  void showDeleteConfirmationDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('계정 삭제'),
          content: Text('정말로 계정을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
          actions: [
            TextButton(
              child: Text('아니오'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // 대화상자 닫기
              },
            ),
            TextButton(
              child: Text('예'),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // 대화상자 닫기
                final userId = SharePrefManager.getUserId();
                if (userId != null) {
                  try {
                    await sessionManager.deleteAccount();
                    print("계정 삭제 성공");
                    if (parentContext.mounted) {
                      Navigator.pushReplacementNamed(parentContext, '/home');
                    }
                  } catch (e) {
                    print("계정 삭제 실패: $e");
                    if (parentContext.mounted) {
                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        SnackBar(content: Text('계정 삭제 실패. 다시 시도하세요.')),
                      );
                    }
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }


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
                Navigator.push( context, MaterialPageRoute(builder: (context) => InquiryScreen()), );
              },
              trailing: Icon(Icons.keyboard_arrow_right, color: AppColors.textWhite), // 아이콘 색상 변경
            ),
            ListTile(
              title: Text('공지사항', style: TextStyle(color: AppColors.textWhite)), // 텍스트 색상 변경
              onTap: () {
                Navigator.push( context, MaterialPageRoute(builder: (context) => NoticesScreen()), );
              },
              trailing: Icon(Icons.keyboard_arrow_right, color: AppColors.textWhite), // 아이콘 색상 변경
            ),
            Divider(color: AppColors.textWhite), // 두 번째 구분선 색상 변경
            ListTile(
              title: Text('로그아웃', style: TextStyle(color: AppColors.textWhite)), // 텍스트 색상 변경
              onTap: () {
                logout(context); // 로그아웃 처리 로직
              },
              trailing: Icon(Icons.exit_to_app, color: AppColors.textWhite), // 아이콘 색상 변경
            ),
            ListTile(
              title: Text('계정 삭제', style: TextStyle(color: AppColors.textWhite)), // 텍스트 색상 변경
              onTap: () {
                showDeleteConfirmationDialog(context); // 계정 삭제 확인 대화상자 띄우기
              },
              trailing: Icon(Icons.delete_forever, color: AppColors.textWhite), // 아이콘 색상 변경
            ),
          ],
        ),
      ),
    );

  }

}