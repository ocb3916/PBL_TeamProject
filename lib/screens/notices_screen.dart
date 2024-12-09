import 'package:flutter/material.dart';
import '../uikit/widgets/top_bar.dart';
import '../uikit/widgets/sub_title.dart';
import '../constants/colors.dart';

class NoticesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: Container(
        color: AppColors.background,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubTitle(title: '공지사항'),
            ListTile(
              title: Text('공지사항 1', style: TextStyle(color: AppColors.textWhite)),
              onTap: () {
                // 공지사항 1 상세 화면으로 이동
              },
              trailing: Icon(Icons.keyboard_arrow_right, color: AppColors.textWhite),
            ),
            Divider(color: AppColors.textWhite),
            ListTile(
              title: Text('공지사항 2', style: TextStyle(color: AppColors.textWhite)),
              onTap: () {
                // 공지사항 2 상세 화면으로 이동
              },
              trailing: Icon(Icons.keyboard_arrow_right, color: AppColors.textWhite),
            ),
            Divider(color: AppColors.textWhite),
            ListTile(
              title: Text('공지사항 3', style: TextStyle(color: AppColors.textWhite)),
              onTap: () {
                // 공지사항 3 상세 화면으로 이동
              },
              trailing: Icon(Icons.keyboard_arrow_right, color: AppColors.textWhite),
            ),
          ],
        ),
      ),
    );
  }
}
