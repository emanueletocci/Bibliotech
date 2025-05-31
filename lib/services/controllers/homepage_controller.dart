/*
 *  Questo controller implementa la logica di generazione delle liste di libri consigliati e delle ultime aggiunte nella homepage
 */

import '../../models/citazione_model.dart';
import '../../models/libreria_model.dart';
import '../../models/libro_model.dart';
import 'dart:math';

/// Controller per la gestione della homepage.
/// Genera le liste di libri consigliati e delle ultime aggiunte.
class HomepageController {
  /// Riferimento alla libreria dell'utente.
  final Libreria libreria;

  /// Data dell'ultimo aggiornamento della lista consigliati.
  DateTime? _date;

  /// Cache dei libri consigliati.
  List<Libro>? _cachedConsigliati;

  /// Numero massimo di libri da mostrare.
  final int numLibri = 5;

  /// Costruttore che riceve la libreria da gestire.
  HomepageController(this.libreria);

  DateTime get _now => DateTime.now();
  DateTime get _today => DateTime(_now.year, _now.month, _now.day);

  Citazione get citazioneDelGiorno {
    final giornoCorrente = _today.day;
    // sottraggo 1 per avere un indice 0-based
    // l'operatore modulo mi consente di mostrare una citazione diversa ogni giorno
    final index = (giornoCorrente - 1) % _citazioni.length;
    return _citazioni[index];
  }

  List<Libro> get libriConsigliati {
    // Se la cache è nulla o la data è cambiata, rigenera la lista
    if (_cachedConsigliati == null ||
        _date == null ||
        _date!.isBefore(_today)) {
      _date = _today;
      _cachedConsigliati = _generaLibriConsigliati();
    }
    // Invalida la cache se la lista dei libri è cambiata (controlla la lunghezza)
    if (_cachedConsigliati!.length != libreria.getLibri().length) {
      _cachedConsigliati = _generaLibriConsigliati();
    }
    return _cachedConsigliati!;
  }

  /// Genera una lista casuale di libri consigliati dalla libreria.
  List<Libro> _generaLibriConsigliati() {
    final libri = libreria.getLibri();

    if (libri.isEmpty) {
      return [];
    }
    // Random accetta un intero quindi uso i millisecondi della data corrente come seme
    final random = Random(_date!.millisecondsSinceEpoch);
    final booksToShuffle = List<Libro>.from(libri);
    booksToShuffle.shuffle(random);
    return booksToShuffle.take(min(numLibri, libri.length)).toList();
  }

  /// Restituisce la lista delle ultime aggiunte alla libreria.
  List<Libro> get ultimeAggiunte {
    final libri = libreria.getLibri();
    if (libri.isEmpty) {
      return [];
    }
    return libri.reversed.take(min(numLibri, libri.length)).toList();
  }

  // Definisco direttamente qui le citazioni per semplicitá...
  static const List<Citazione> _citazioni = [
    Citazione(
      testo:
          "Tutti i grandi sono stati bambini una volta. Ma pochi di essi se ne ricordano.",
      autore: "Antoine de Saint-Exupéry",
      libro: "Il piccolo principe",
    ),
    Citazione(
      testo:
          "Non si vede bene che col cuore. L’essenziale è invisibile agli occhi.",
      autore: "Antoine de Saint-Exupéry",
      libro: "Il piccolo principe",
    ),
    Citazione(
      testo: "Chi non legge, a 70 anni avrà vissuto una sola vita: la propria.",
      autore: "Umberto Eco",
      libro: "Il nome della rosa",
    ),
    Citazione(
      testo:
          "Un classico è un libro che non ha mai finito di dire quello che ha da dire.",
      autore: "Italo Calvino",
      libro: "Perché leggere i classici",
    ),
    Citazione(
      testo:
          "Leggere è andare incontro a qualcosa che sta per essere e ancora nessuno sa cosa sarà.",
      autore: "Italo Calvino",
      libro: "Se una notte d'inverno un viaggiatore",
    ),
    Citazione(
      testo:
          "Un lettore vive mille vite prima di morire. Colui che non legge mai ne vive solo una.",
      autore: "George R.R. Martin",
      libro: "A Dance with Dragons",
    ),
    Citazione(
      testo: "I libri sono specchi: si vede solo ciò che si ha dentro.",
      autore: "Carlos Ruiz Zafón",
      libro: "L'ombra del vento",
    ),
    Citazione(
      testo: "Apri un libro e lo apri al mondo.",
      autore: "Amy Lowell",
      libro: "Varie opere",
    ),
    Citazione(
      testo: "Ogni libro è un viaggio, ogni lettura un'avventura.",
      autore: "Carl Sagan",
      libro: "Cosmos",
    ),
    Citazione(
      testo: "Non c'è peggior ladrone di un cattivo libro.",
      autore: "Miguel de Cervantes",
      libro: "Don Chisciotte della Mancia",
    ),
    Citazione(
      testo:
          "Ho imparato da tempo che quando si legge un buon libro, la gente è in grado di capire il suo messaggio.",
      autore: "Haruki Murakami",
      libro: "Kafka sulla spiaggia",
    ),
    Citazione(
      testo: "Il modo migliore per evadere da un problema è risolverlo.",
      autore: "Stephen King",
      libro: "Non specificato",
    ),
    Citazione(
      testo:
          "Non siamo nati per leggere libri, siamo nati per scrivere storie.",
      autore: "J.K. Rowling",
      libro: "Non specificato",
    ),
    Citazione(
      testo: "La lettura è per la mente ciò che l'esercizio è per il corpo.",
      autore: "Joseph Addison",
      libro: "The Spectator",
    ),
    Citazione(
      testo: "Un libro, come un amico, dovrebbe essere scelto con cura.",
      autore: "Charles Caleb Colton",
      libro: "Laconics",
    ),
  ];
}
