import 'package:flutter/material.dart';
import 'screens/home/homepage.dart';
import 'widgets/barra_navigazione.dart';
import 'themes/themes.dart';
import 'screens/dettagli_libro/tab_bar.dart';

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
      home: const TabView(), // Punto di ingresso
      debugShowCheckedModeBanner: false,
    );
  }
}
