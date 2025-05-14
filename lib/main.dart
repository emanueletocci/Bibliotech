import 'package:flutter/material.dart';
import 'screens/home/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    title: 'Bibliotech',
      home: HomeScreen(title: 'Homepage'),
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: const TextTheme(
          
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
          bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
          bodySmall: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Roboto',
          ),
        ),
        buttonTheme: ButtonThemeData()
      ),
    );
  }
}
