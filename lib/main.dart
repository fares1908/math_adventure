import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MathAdventureApp());
}

class MathAdventureApp extends StatelessWidget {
  const MathAdventureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Adventure',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE0F7FA),
        useMaterial3: false,
      ),
      home: const HomeScreen(),
    );
  }
}
