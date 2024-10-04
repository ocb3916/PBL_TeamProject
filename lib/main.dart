import 'package:flutter/material.dart';
import 'screens/main_screen.dart'; // MainScreen import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Recommendation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(), // 시작 화면은 MainScreen으로 설정
      // routes는 필요에 따라 확장하여 사용할 수 있습니다.
      routes: {
        '/home': (context) => MainScreen(),
        '/search': (context) => MainScreen(),
        '/profile': (context) => MainScreen(),
        // 로그인의 필요에 따라 추가적인 화면을 달리 표시할 수 있습니다.
      },
    );
  }
}
