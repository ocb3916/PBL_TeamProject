import 'package:flutter/material.dart';
import '../../screens/home_screen.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // AppBar의 높이를 설정

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      alignment: AlignmentDirectional.centerStart,
      color: Colors.black, // 원하는 색상으로 설정
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/home');
        },
        child: Image.asset(
          "images/logo.png",
          fit: BoxFit.contain,
          height: kToolbarHeight,
        ),
      ),
    );
  }
}
