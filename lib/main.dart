import 'package:correcting_time/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Correcting Time',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFD1AF67),
        accentColor: Color(0xFFFCF5D5),
      ),
      home: HomeScreen(),
    );
  }
}
