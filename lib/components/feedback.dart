import 'package:flutter/material.dart';

/// Funzione helper generica per gestire operazioni asincrone della UI
/// che coinvolgono un controller e mostrano feedback (SnackBar, navigazione).
void handleControllerOperation({
  required BuildContext context,
  // Funzione eseguita dal controller
  required Future<void> Function() operation,
  required String successMessage,
})  async {
  // Verifico che il BuildContext sia valido

  try {
    await operation(); // Eseguo l'operazione asincrona del controller

    if (!context.mounted) return;
    // Se l'operazione ha successo, mostro la SnackBar di successo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(successMessage),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );

    // Aspetto prima di fare il pop per permettere all'utente di leggere la SnackBar
    // restituisce un Future
    await Future.delayed(const Duration(seconds: 2));

    // Controllo `mounted` prima della navigazione
    if (!context.mounted) return;
    Navigator.of(context).pop(true); // Segnalo successo!
  } catch (e) {
    // In caso di errore, estraggo il messaggio e lo mostro in una SnackBar di errore
    String errorMessage = e.toString();
    const prefix = 'Exception: ';
    if (errorMessage.startsWith(prefix)) {
      // Rimuovo il prefisso "Exception: " dal messaggio di errore
      errorMessage = errorMessage.substring(prefix.length);
    }

    // Controllo `mounted` prima di mostrare la SnackBar di errore
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
