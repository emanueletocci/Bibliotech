import 'package:flutter/foundation.dart';
import 'libro.dart';

class Libreria extends ChangeNotifier {
  // Implementazione del Singleton con integrazione Provider (ChangeNotifier)
  // Pattern che garantisce una sola istanza della libreria, con notifiche automatiche agli observer
  // https://docs.flutter.dev/data-and-backend/state-mgmt/simple#changenotifier

  static final Libreria _instance = Libreria._privateConstructor();

  /// Costruttore factory che restituisce l'istanza singleton
  /// Chiamando Libreria() si ottiene sempre la stessa istanza condivisa
  factory Libreria() => _instance;

  /// Costruttore privato per il singleton (previene creazioni esterne)
  Libreria._privateConstructor();

  // Struttura dati principale per la gestione dei libri
  // - Key: ISBN del libro (gestione duplicati automatica)
  // - Value: Istanza del libro
  final Map<String, Libro> _libri = {};

  /// Getter che restituisce il numero totale di libri (accesso: libreria.numeroTotaleLibri)
  int get numeroTotaleLibri => _libri.length;

  /// Aggiunge un libro alla libreria se non presente
  /// Notifica automaticamente i listener tramite ChangeNotifier
  void aggiungiLibro(Libro libro) {
    _libri.putIfAbsent(libro.isbn, () => libro);
    notifyListeners(); // Trigger per il rebuild dei widget ascoltatori
  }

  /// Rimuove un libro 
  /// Solleva eccezione se l'ISBN non esiste
  void rimuoviLibro(Libro libro) {
    if (_libri.containsKey(libro.isbn)) {
      _libri.remove(libro.isbn);
      notifyListeners();
    } else {
      throw Exception("ISBN non trovato");
    }
  }

  // Metodo helper per la modifica di un libro. Dato che uso una mappa, 
  // in realtá rimuovo il vecchio libro e aggiungo quello nuovo.
  // senza dover modificare manualmente le chiavi della mappa
  void modificaLibro(Libro vecchioLibro, Libro nuovoLibro) {
    rimuoviLibro(vecchioLibro);
    aggiungiLibro(nuovoLibro);
  }

  /// Ricerca per titolo (case insensitive)
  /// Restituisce il primo libro che contiene la stringa cercata nel titolo
  Libro? cercaLibroPerNome(String nome) {
    for (var libro in _libri.values) {
      if (libro.titolo.toLowerCase().contains(nome.toLowerCase())) {
        return libro;
      }
    }
    return null;
  }

  /// Ricerca diretta tramite ISBN (O(1) complexity)
  Libro? cercaLibroPerIsbn(String isbn) {
    return _libri[isbn];
  }

  /// Ricerca generica con callback per filtri personalizzati
  /// Es: cerca((libro) => libro.annoPubblicazione > 2000)
  List<Libro> cerca(bool Function(Libro) criterio) {
    return _libri.values.where(criterio).toList();
  }

  /// Restituisce tutti i libri come lista ordinata
  /// Utile per visualizzazioni che richiedono ListView/GridView
  List<Libro> getLibri() {
    return _libri.values.toList();
  }
}
