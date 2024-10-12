import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/colors.dart'; // AppColors에 맞는 경로
import '../uikit/widgets/top_bar.dart'; // TopBar 임포트
import 'settings_screen.dart'; // "설정" 페이지로 이동을 위해 임포트

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // 배경색 설정
      appBar: TopBar(),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid) // 현재 로그인한 사용자 UID로 문서 조회
            .get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // 로딩 중 표시
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // 사용자의 정보 가져오기
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Center(child: Text('사용자 정보가 없습니다.'));
          }

          var userDoc = snapshot.data!;
          String name = userDoc['name'] ?? 'Unknown';
          String nickname = userDoc['nickname'] ?? 'Unknown';
          String email = userDoc['email'] ?? 'Unknown';
          String gender = userDoc['gender'] ?? 'Unknown';
          // Timestamp에서 생년월일을 가져오기
          DateTime dateOfBirth = (userDoc['dateOfBirth'] as Timestamp).toDate();

          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 프로필 사진 및 정보 표시
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
                          nickname,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textWhite,
                          ),
                        ),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textWhite,
                          ),
                        ),
                        Text(
                          '성별: $gender',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textWhite,
                          ),
                        ),
                        Text(
                          '생년월일: ${dateOfBirth.toLocal().toString().split(' ')[0]}', // YYYY-MM-DD 형식으로 변환
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textWhite,
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
                        leading: Icon(Icons.favorite, color: AppColors.textWhite),
                        title: Text('관심목록', style: TextStyle(color: AppColors.textWhite)),
                        onTap: () {
                          // 관심목록 페이지로 이동, 관련된 작업 구현
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.history, color: AppColors.textWhite),
                        title: Text('시청기록', style: TextStyle(color: AppColors.textWhite)),
                        onTap: () {
                          // 시청기록 페이지로 이동, 관련된 작업 구현
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.rate_review, color: AppColors.textWhite),
                        title: Text('리뷰 관리', style: TextStyle(color: AppColors.textWhite)),
                        onTap: () {
                          // 리뷰 관리 페이지로 이동, 관련된 작업 구현
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.settings, color: AppColors.textWhite),
                        title: Text('설정', style: TextStyle(color: AppColors.textWhite)),
                        onTap: () {
                          // 설정 화면으로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SettingsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
