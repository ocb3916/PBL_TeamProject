import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/SessionManager.dart';
import 'SharedPreference.dart';
import 'screens/main_screen.dart'; // MainScreen import
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharePrefManager.init(); // SharedPreferences 초기화
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
      home: MainScreen(),
      routes: {
        '/home': (context) => MainScreen(),
        '/search': (context) => MainScreen(),
        '/profile': (context) => MainScreen(),
      },
    );
  }

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') != null; // ID가 있으면 true
  }

}
