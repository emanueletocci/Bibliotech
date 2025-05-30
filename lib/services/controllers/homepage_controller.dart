/*
 *  Questo controller implementa la logica di generazione delle liste di libri consigliati e delle ultime aggiunte nella homepage
 */
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

  /// Restituisce la lista dei libri consigliati per la homepage.
  /// La lista viene aggiornata una volta al giorno o se la libreria cambia.
  List<Libro> get libriConsigliati {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Se la cache è nulla o la data è cambiata, rigenera la lista
    if (_cachedConsigliati == null || _date == null || _date!.isBefore(today)) {
      _date = today;
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
}
