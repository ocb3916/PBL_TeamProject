import 'package:flutter/material.dart';
import 'package:untitled1/data/user_data.dart'; // UserData import 추가
import 'package:untitled1/screens/review_list_screen.dart';
import 'package:untitled1/screens/settings_screen.dart';
import 'package:untitled1/screens/user_review_screen.dart';
import 'package:untitled1/screens/watch_movie_screen.dart';
import '../SharedPreference.dart';
import '../constants/colors.dart';
import '../uikit/widgets/top_bar.dart';
import 'favorite_movie_screen.dart';
import 'edit_profile_screen.dart'; // 새로운 수정 화면 import

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userProfile;
  late bool _isLoggedIn; // 초기 상태는 null

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final userId = SharePrefManager.pref.getString(SharedPrefConst.USER_ID);

    if (userId != null) {
      try {
        UserData userData = UserData();
        final profile = await userData.fetchUserProfile(userId);
        setState(() {
          userProfile = profile;
        });
      } catch (e) {
        print("오류: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: TopBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (userProfile != null) ...[
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://via.placeholder.com/80'),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProfile!['nickName'] ?? '닉네임 없음',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textWhite,
                        ),
                      ),
                      Text(
                        userProfile!['email'] ?? '이메일 없음',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textWhite,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                userId: userProfile!['id'],
                                email: userProfile!['email'],
                                nickName: userProfile!['nickName'],
                              ),
                            ),
                          );
                        },
                        child: Text(
                          '프로필 수정',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.favorite, color: AppColors.textWhite),
                    title: Text('관심목록', style: TextStyle(color: AppColors.textWhite)),
                    onTap: () {
                      final userId = userProfile!['id']; // 프로필에서 사용자 ID 가져오기
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FavoriteMoviesScreen(userId: userId)),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.history, color: AppColors.textWhite),
                    title: Text('시청기록', style: TextStyle(color: AppColors.textWhite)),
                    onTap: () {
                      final userId = userProfile!['id']; // 프로필에서 사용자 ID 가져오기
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WatchedMoviesScreen(userId: userId)),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.rate_review, color: AppColors.textWhite),
                    title: Text('리뷰 관리', style: TextStyle(color: AppColors.textWhite)),
                    onTap: () {
                      final userId = userProfile!['id']; // id 가져오기
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserReviewScreen(userId: userId)),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: AppColors.textWhite),
                    title: Text('설정', style: TextStyle(color: AppColors.textWhite)),
                    onTap: () {
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
      ),
    );
  }
}
