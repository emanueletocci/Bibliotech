import 'package:bibliotech/screens/main_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'themes/themes.dart';
import 'models/libreria.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // create defisce la classe che implementa ChangeNotifier, in questo caso Libreria
      // fornisce una istanza di ChangeNotifier ai suoi figli
      create: (context) => Libreria(),
      child: MaterialApp(
        title: 'Bibliotech',
        theme: appTheme,
        home: const MainScreen(),
      ),
      );

  }
}
