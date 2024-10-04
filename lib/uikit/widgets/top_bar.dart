import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // AppBar의 높이를 설정

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true, // 제목을 가운데로 설정
      title: Text('앱 제목'),
      backgroundColor: Colors.blue, // 원하는 색상으로 설정
      automaticallyImplyLeading: true, // 뒤로가기 버튼 포함
    );
  }
}
