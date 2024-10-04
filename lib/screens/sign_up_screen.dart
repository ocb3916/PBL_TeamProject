import 'package:flutter/material.dart';
import '../uikit/widgets/top_bar.dart'; // TopBar import 추가
import 'login_screen.dart';
import 'main_screen.dart'; // MainScreen import 추가

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(), // TopBar 사용
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('회원가입', style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // 회원가입 성공 후 MainScreen으로 이동
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()), // 회원가입 후 MainScreen으로 리다이렉트
                  );
                },
                child: Text('회원가입'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // 로그인 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen(loginCallback: (status) {})), // 로그인 페이지로 이동
                  );
                },
                child: Text('이미 계정이 있으신가요? 로그인'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
        currentIndex: 2, // 현재 선택된 항목: 마이페이지
        onTap: (index) {
          switch (index) {
            case 0:
            // 홈화면으로 이동
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
            // 검색화면으로 이동
              Navigator.pushReplacementNamed(context, '/search');
              break;
            case 2:
            // 이미 마이페이지에 있을 때
              break; // 이미 이 위치에 있습니다
          }
        },
      ),
    );
  }
}
