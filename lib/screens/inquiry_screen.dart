import 'package:flutter/material.dart';
import '../uikit/widgets/top_bar.dart';
import '../uikit/widgets/sub_title.dart';
import '../constants/colors.dart';

class InquiryScreen extends StatelessWidget {
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
            SubTitle(title: '문의하기/FAQ'),
            ListTile(
              title: Text('자주 묻는 질문', style: TextStyle(color: AppColors.textWhite)),
              onTap: () {
                // 자주 묻는 질문 화면으로 이동
              },
              trailing: Icon(Icons.keyboard_arrow_right, color: AppColors.textWhite),
            ),
            Divider(color: AppColors.textWhite),
            ListTile(
              title: Text('고객센터 연락처', style: TextStyle(color: AppColors.textWhite)),
              onTap: () {
                // 고객센터 연락처 화면으로 이동
              },
              trailing: Icon(Icons.keyboard_arrow_right, color: AppColors.textWhite),
            ),
            Divider(color: AppColors.textWhite),
            ListTile(
              title: Text('문의하기', style: TextStyle(color: AppColors.textWhite)),
              onTap: () {
                // 문의하기 화면으로 이동
              },
              trailing: Icon(Icons.keyboard_arrow_right, color: AppColors.textWhite),
            ),
          ],
        ),
      ),
    );
  }
}
