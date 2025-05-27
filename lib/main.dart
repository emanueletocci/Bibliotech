import 'dart:io';
import 'package:bibliotech/screens/main_view.dart';
import 'package:flutter/material.dart';
import 'models/libreria.dart';
import 'themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  // Assicuro che il framwork Flutter sia inizializzato prima di eseguire interazioni con il SO o plugin nativi
  WidgetsFlutterBinding.ensureInitialized();

  // Il plugin sqflite non funziona su desktop, occorre utilizzare sqflite_ffi
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

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