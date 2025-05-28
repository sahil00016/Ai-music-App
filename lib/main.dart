import 'package:flutter/material.dart';
import 'package:gesture_voice_control_app/constants/theme.dart';
import 'package:gesture_voice_control_app/screens/main_menu_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gesture & Voice Control',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const MainMenuScreen(),
    );
  }
} 