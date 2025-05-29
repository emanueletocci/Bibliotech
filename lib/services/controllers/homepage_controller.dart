/*
 *  Questo controller implementa la logica di generazione delle liste di libri consigliati e delle ultime aggiunte nella homepage
 */
import '../../models/libreria.dart';
import '../../models/libro.dart';
import 'dart:math';

class HomepageController {
  final Libreria libreria;
  DateTime? _date;
  List<Libro>? _cachedConsigliati;
  final int numLibri = 5;

  HomepageController(this.libreria);

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

  List<Libro> get ultimeAggiunte {
    final libri = libreria.getLibri();
    if (libri.isEmpty) {
      return [];
    }
    return libri.reversed.take(min(numLibri, libri.length)).toList();
  }
}
