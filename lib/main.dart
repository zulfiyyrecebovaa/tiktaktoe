import 'package:flutter/material.dart';
import 'pages/setup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NxMxK Tic Tac Toe',
      home: const PlayerSetupPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}