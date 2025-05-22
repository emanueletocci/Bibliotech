import '../../models/libreria.dart';
import '../../models/libro.dart';
import 'dart:math';

class HomepageController {
  final Libreria _libreria = Libreria();

   // uso la data odierna per randomizzare i libri consigliati
  late DateTime _date;
  
  // mantengo una lista cache dei libri consigliati
  List<Libro>? _cachedConsigliati; 
  
  final int numLibri = 5; // Numero di libri da consigliare

  List<Libro> get libriConsigliati {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_cachedConsigliati == null || _date.isBefore(today)) {
      _date = today;
      _cachedConsigliati = _generaLibriConsigliati();
    }
    return _cachedConsigliati!;
  }

  List<Libro> _generaLibriConsigliati() {
    final libri = _libreria.getLibri();

    if (libri.isEmpty) {
      return []; // Nessun libro disponibile!
    }

    // Uso la data odierna come seed
    final random = Random(_date.millisecondsSinceEpoch);

    final List<Libro> booksToShuffle = List.from(
      libri,
    ); // Copia della lista di libri

    // mescolo i libri utilizzando il seed. Shuffle restituisce void quindi non posso concatenare
    // direttamente il metodo take
    booksToShuffle.shuffle(random);

    // Prendo i primi 5 libri (se ci sono almeno 5 libri),
    final List<Libro> libriConsigliati =
        booksToShuffle.take(min(numLibri, libri.length)).toList();

    return libriConsigliati;
  }

  List<Libro> get ultimeAggiunte {
    final libri = _libreria.getLibri();
    if (libri.isEmpty) {
      return []; // Nessun libro disponibile!
    }
    // Prendo gli ultimi 5 libri (se ci sono almeno 5 libri),
    return libri.reversed.take(min(numLibri, libri.length)).toList();
  }
}
