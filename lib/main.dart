import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const HospitalApp());
}

class HospitalApp extends StatelessWidget {
  const HospitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RS Sehat Sentosa',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const WelcomeScreen(),
    );
  }
}
