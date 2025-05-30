import 'package:flutter/material.dart';

/// Tema principale dell'applicazione.
/// Definisce font, schema colori e utilizzo di Material 3.
final ThemeData appTheme = ThemeData(
  fontFamily: 'Roboto',
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
);
