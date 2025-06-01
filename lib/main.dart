import 'package:bibliotech/screens/main/main_view.dart';
import 'package:flutter/material.dart';
import 'models/libreria_model.dart';
import 'themes/themes.dart';
import 'package:provider/provider.dart';

/// Funzione principale dell'applicazione.
/// Inizializza Flutter, configura il database e avvia l'app.
void main() async {
  // Assicuro che il framwork Flutter sia inizializzato prima di eseguire interazioni con il SO o plugin nativi
  WidgetsFlutterBinding.ensureInitialized();

  final libreria = Libreria();
  // Inizializz la libreria caricando i libri dal database
  await libreria.init();

  runApp(
    ChangeNotifierProvider<Libreria>(create: (_) => libreria, child: MyApp()),
  );
}

/// Widget principale dell'applicazione.
/// Imposta il tema e la schermata iniziale.
class MyApp extends StatelessWidget {
  /// Costruttore della classe [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bibliotech',
      theme: appTheme,
      home: const MainView(),
    );
  }
}
