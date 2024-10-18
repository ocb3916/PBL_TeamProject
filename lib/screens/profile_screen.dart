import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/SessionManager.dart';
import '../constants/colors.dart';
import '../uikit/widgets/top_bar.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool _isLoggedIn; // 초기 상태는 null

  @override
  void initState() {
    super.initState();
    if(Sessionmanager.isLogin()) {
      setState(() {
        _isLoggedIn = true;
      });
    } else {
      setState(() {
        _isLoggedIn = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    // TODO 로그인 상태에 따른 위젯 설정
    // 로그인 되어있을때 위젯
    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Text(
    //       nickname,
    //       style: TextStyle(
    //         fontSize: 18,
    //         fontWeight: FontWeight.bold,
    //         color: AppColors.textWhite,
    //       ),
    //     ),
    //     Text(
    //       email,
    //       style: TextStyle(
    //         fontSize: 14,
    //         color: AppColors.textWhite,
    //       ),
    //     ),
    //     Text(
    //       '성별: $gender',
    //       style: TextStyle(
    //         fontSize: 14,
    //         color: AppColors.textWhite,
    //       ),
    //     ),
    //     Text(
    //       '생년월일: ${dateOfBirth.toLocal().toString().split(' ')[0]}', // YYYY-MM-DD 형식으로 변환
    //       style: TextStyle(
    //         fontSize: 14,
    //         color: AppColors.textWhite,
    //       ),
    //     ),
    //   ],
    // ),
    Widget profileWidget = _isLoggedIn ? Container() : Container();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: TopBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage('https://via.placeholder.com/80'),
                ),
                SizedBox(width: 10),
                profileWidget
              ],
            ),
            SizedBox(height: 20),
            profileWidget, // 로그인 여부에 따른 위젯 표시
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.favorite, color: AppColors.textWhite),
                    title: Text('관심목록', style: TextStyle(color: AppColors.textWhite)),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.history, color: AppColors.textWhite),
                    title: Text('시청기록', style: TextStyle(color: AppColors.textWhite)),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.rate_review, color: AppColors.textWhite),
                    title: Text('리뷰 관리', style: TextStyle(color: AppColors.textWhite)),
                    onTap: () {},
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
