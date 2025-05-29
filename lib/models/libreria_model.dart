import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'genere_libro_model.dart';
import 'libro_model.dart';
import '../services/dao/db.dart';
import 'stato_libro_model.dart';

class Libreria extends ChangeNotifier {
  // Implementazione del Singleton con integrazione Provider (ChangeNotifier)
  // Pattern che garantisce una sola istanza della libreria, con notifiche automatiche agli observer
  // https://docs.flutter.dev/data-and-backend/state-mgmt/simple#changenotifier

  static final Libreria _instance = Libreria._privateConstructor();

  // Costruttore factory che restituisce l'istanza singleton
  // Chiamando Libreria() si ottiene sempre la stessa istanza condivisa
  factory Libreria() => _instance;

  // Costruttore privato per il singleton (previene creazioni esterne)
  Libreria._privateConstructor();

  // Struttura dati principale per la gestione dei libri
  // - Key: ISBN del libro (gestione duplicati automatica)
  // - Value: Istanza del libro
  final Map<String, Libro> _libri = {};

  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Variabile per tenere traccia dell'inizializzazione della mappa interna e gestire il caricamento
  // automatico dei libri all'avvio dell'app a partire dal database
  bool _isInitialized = false;

  // Getter che restituisce il numero totale di libri (accesso: libreria.numeroTotaleLibri)
  // I getter si chiamano come proprietá, utilizzando la dot notation
  int get numeroTotaleLibri => _libri.length;

  // -- METODI DI UTILITÁ

  // Per garantire coerenza tra dati in memoria e nel database si é deciso di implementare prima la
  // inserimento nel db e solo dopo l'aggiornamento della mappa interna.
  // Questo approccio garantisce che la mappa interna sia sempre sincronizzata con il database in quanto,
  // se l'inserimento nel database fallisce, non si aggiorna la mappa interna.

  // Metodo di inizializzazione che carica i libri dal database nella mappa interna
  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;
    final libri = await _dbHelper.getAllLibri();
    _libri.addAll({for (var l in libri) l.isbn: l});
    notifyListeners();
  }

  // Aggiunge un libro alla libreria se non presente
  Future<void> aggiungiLibro(Libro libro) async {
    try {
      //Provo a inserire nel database. Uso await per attendere il completamento dell'operazione
      await _dbHelper.insertLibro(libro);
      //Solo se il database ha successo, aggiorno la mappa interna
      _libri.putIfAbsent(libro.isbn, () => libro);
      notifyListeners();
    } catch (e) {
      debugPrint('Errore inserimento libro: $e');
    }
  }

  Future<void> rimuoviLibro(Libro libro) async {
    try {
      await _dbHelper.deleteLibro(libro.isbn);
      if (_libri.containsKey(libro.isbn)) {
        _libri.remove(libro.isbn);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Errore rimozione libro: $e');
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

  // Ricerca per titolo (case insensitive)
  // Restituisce il primo libro che contiene la stringa cercata nel titolo
  Libro? cercaLibroPerNome(String nome) {
    for (var libro in _libri.values) {
      if (libro.titolo.toLowerCase().contains(nome.toLowerCase())) {
        return libro;
      }
    }
    return null;
  }

  Libro? cercaLibroPerIsbn(String isbn) {
    return _libri[isbn];
  }

  // Ricerca generica con callback per filtri personalizzati (tipo java lambda)
  // Es: cerca((libro) => libro.annoPubblicazione > 2000)
  List<Libro> cerca(bool Function(Libro) criterio) {
    return _libri.values.where(criterio).toList();
  }

  // Restituisce i libri in base al genere specificato
  List<Libro> getLibriPerGenere(GenereLibro? genere) {
    if (genere == null) {
      return getLibri(); // Restituisco tutti i libri se il genere è null
    }
    return cerca((libro) => libro.genere == genere);
  }

  // Restituisce i libri in base allo stato specificato
  List<Libro> getLibriPerStato(StatoLibro? stato) {
    if (stato == null) {
      return getLibri(); // Restituisco tutti i libri se lo stato è null
    }
    return cerca((libro) => libro.stato == stato);
  }

  // Metodo helper per il filtraggio combinato dei libri
  // Permette di filtrare per genere, stato e preferiti e ricerca contemporaneamente
  List<Libro> getLibriFiltrati({
    GenereLibro? genere,
    StatoLibro? stato,
    bool soloPreferiti = false,
    String? titolo,
  }) {
    return cerca((libro) {
      final genereOk = genere == null || libro.genere == genere;
      final statoOk = stato == null || libro.stato == stato;
      final preferitiOk = !soloPreferiti || libro.preferito;
      final titoloOk =
          titolo == null ||
          libro.titolo.toLowerCase().contains(titolo.toLowerCase());
      return genereOk && statoOk && preferitiOk && titoloOk;
    });
  }

  // Restituisce tutti i libri come lista ordinata
  // Utile per visualizzazioni che richiedono ListView/GridView
  List<Libro> getLibri() {
    return _libri.values.toList();
  }
}
