import 'package:bibliotech/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home/homepage.dart';
import 'themes/themes.dart';
import 'widgets/barra_navigazione.dart';

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
      home: const MainScreen(),
    );
  }
}
