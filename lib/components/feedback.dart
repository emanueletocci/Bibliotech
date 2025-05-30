/*
 * Questo file contiene l'implementazione di una funzione helper per la gestione dei feedback all'utente sotto forma di
 * SnackBar. Generalmente é utilizzata insieme ai vari controller per gestire le operazioni di aggiunta, modifica o cancellazione
 */
import 'package:flutter/material.dart';

/// Funzione helper generica per gestire operazioni asincrone della UI
/// che coinvolgono un controller e mostrano feedback (SnackBar, navigazione).
///
/// Mostra una SnackBar di successo se l'operazione va a buon fine.
/// In caso di errore, mostra una SnackBar di errore con il messaggio estratto dall'eccezione.
/// Dopo il successo, attende 2 secondi e chiude la schermata corrente.
///
/// Parametri:
/// - [context]: Il contesto di build corrente.
/// - [operation]: La funzione asincrona da eseguire (ad esempio aggiunta, modifica, cancellazione).
/// - [successMessage]: Il messaggio da mostrare nella SnackBar in caso di successo.
void handleControllerOperation({
  required BuildContext context,
  // Funzione eseguita dal controller
  required Future<void> Function() operation,
  required String successMessage,
}) async {
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
