import 'package:flutter/material.dart';
import 'screens/main_screen.dart'; // MainScreen import
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase 초기화
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
}
