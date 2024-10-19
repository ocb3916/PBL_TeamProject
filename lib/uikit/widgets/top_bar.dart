import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // AppBar의 높이를 설정

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      alignment: AlignmentDirectional.centerStart,
      child: Image.asset("images/logo.png"),
      color: Colors.black, // 원하는 색상으로 설정
    );
  }
}
