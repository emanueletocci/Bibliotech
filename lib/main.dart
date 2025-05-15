import 'package:flutter/material.dart';
import 'screens/home/homepage.dart';
import 'themes/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bibliotech',
      theme: appTheme,
      home: const HomeScreen(title: 'Homepage'),
    );
  }
}
