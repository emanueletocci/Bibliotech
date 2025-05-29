import 'package:flutter/material.dart';

/// Funzione helper generica per gestire operazioni asincrone della UI
/// che coinvolgono un controller e mostrano feedback (SnackBar, navigazione).
Future<void> handleControllerOperation({
  required BuildContext context,
  // Funzione eseguita dal controller
  required Future<void> Function() operation, 
  required String successMessage,
  required String errorMessagePrefix,
  bool popOnSuccess = true, 
}) async {
  // Verifico che il BuildContext sia valido
  if (!context.mounted) return; // Controllo iniziale se richiesto

  try {
    await operation(); // Eseguo l'operazione asincrona del controller

    // Se l'operazione ha successo, mostro la SnackBar di successo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(successMessage),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // Aspetto prima di fare il pop per permettere all'utente di leggere la SnackBar
    await Future.delayed(const Duration(seconds: 2));

    // Controllo `mounted` prima della navigazione
    if (!context.mounted) return;

    if (popOnSuccess) {
      // Se la vista è ancora montata, faccio il pop
      Navigator.of(context).pop(true); // Segnalo successo!
    }
  } catch (e) {
    // In caso di errore, estraggo il messaggio e lo mostro in una SnackBar di errore
    String displayMessage = e.toString();
    if (displayMessage.startsWith(errorMessagePrefix)) {
      displayMessage = displayMessage.substring(errorMessagePrefix.length);
    } else if (displayMessage.startsWith('Exception: ')) { // Cattura anche il caso generico "Exception: "
      displayMessage = displayMessage.substring('Exception: '.length);
    }

    // Controllo `mounted` prima di mostrare la SnackBar di errore
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(displayMessage), backgroundColor: Colors.red),
    );
  }
}