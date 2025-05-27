import 'package:bibliotech/screens/main_view.dart';
import 'package:flutter/material.dart';
import 'models/libreria.dart';
import 'themes/themes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final libreria = Libreria();
  
  // Inizializz la libreria caricando i libri dal database
  await libreria.init(); 

  runApp(
    ChangeNotifierProvider<Libreria>(
      create: (_) => libreria,
      child: MyApp(),
    ),
  );
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