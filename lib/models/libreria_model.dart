import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'genere_libro_model.dart';
import 'libro_model.dart';
import '../services/db/db.dart';
import 'stato_libro_model.dart';

/// Modello dati che rappresenta la libreria.
/// Gestisce l'insieme dei libri, le operazioni CRUD e la sincronizzazione con il database.
/// Implementa il pattern Singleton e notifica i listener tramite [ChangeNotifier].
class Libreria extends ChangeNotifier {
  // Implementazione del Singleton con integrazione Provider (ChangeNotifier)
  // Il pattern Singleton garantisce che esista una sola istanza della libreria e che sia accessibile
  // da qualunque parte dell'applicazione.
  // La chiamata a Libreria() restituirà quindi sempre la stessa istanza...
  // https://docs.flutter.dev/data-and-backend/state-mgmt/simple#changenotifier

  static final Libreria _instance = Libreria._privateConstructor();

  /// Costruttore factory che restituisce l'istanza singleton.
  /// Chiamando [Libreria()] si ottiene sempre la stessa istanza condivisa.
  factory Libreria() => _instance;

  /// Costruttore privato per il singleton (previene creazioni esterne).
  Libreria._privateConstructor();

  /// Struttura dati principale per la gestione dei libri.
  /// - Key: ISBN del libro (gestione duplicati automatica)
  /// - Value: Istanza del libro
  final Map<String, Libro> _libri = {};

  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Variabile per tenere traccia dell'inizializzazione della mappa interna e gestire il caricamento
  /// automatico dei libri all'avvio dell'app a partire dal database.
  bool _isInitialized = false;

  /// Getter che restituisce il numero totale di libri.
  int get numeroTotaleLibri => _libri.length;

  // -- METODI DI UTILITÁ

  // Per garantire coerenza tra dati in memoria e nel database si é deciso di implementare prima la
  // inserimento nel db e solo dopo l'aggiornamento della mappa interna.
  // Questo approccio garantisce che la mappa interna sia sempre sincronizzata con il database in quanto,
  // se l'inserimento nel database fallisce, non si aggiorna la mappa interna.

  /// Metodo di inizializzazione che carica i libri dal database nella mappa interna.
  /// Da chiamare una sola volta all'avvio dell'app.
  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;
    final libri = await _dbHelper.getAllLibri();
    _libri.addAll({for (var l in libri) l.isbn: l});
    notifyListeners();
  }

  /// Aggiunge un libro alla libreria se non presente.
  /// Aggiorna sia il database che la mappa interna.
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

  /// Rimuove un libro dalla libreria e dal database.
  /// Lancia un'eccezione se l'ISBN non viene trovato.
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

  /// Modifica un libro esistente sostituendolo con uno nuovo.
  /// Rimuove il vecchio libro e aggiunge quello nuovo.
  void modificaLibro(Libro vecchioLibro, Libro nuovoLibro) {
    rimuoviLibro(vecchioLibro);
    aggiungiLibro(nuovoLibro);
  }

  /// Ricerca per titolo (case insensitive).
  /// Restituisce il primo libro che contiene la stringa cercata nel titolo.
  Libro? cercaLibroPerNome(String nome) {
    for (var libro in _libri.values) {
      if (libro.titolo.toLowerCase().contains(nome.toLowerCase())) {
        return libro;
      }
    }
    return null;
  }

  /// Ricerca un libro tramite ISBN.
  /// Restituisce il libro se trovato, altrimenti null.
  Libro? cercaLibroPerIsbn(String isbn) {
    return _libri[isbn];
  }

  /// Ricerca generica che restituisce una lista di libri che soddisfano un criterio specificato.
  /// Prende in input una funzione [criterio] che rappresenta il filtro di ricerca. 
  /// Il metodo inserisce nella lista solo i libri che soddisfano il criterio, ovvero quelli per cui la funzione [criterio] restituisce true.
  /// Esempio: cerca((libro) => libro.annoPubblicazione > 2000)
  
  List<Libro> cerca(bool Function(Libro) criterio) {
    return _libri.values.where(criterio).toList();
  }

  /// Restituisce i libri in base al genere specificato.
  /// Se [genere] è null, restituisce tutti i libri.
  List<Libro> getLibriPerGenere(GenereLibro? genere) {
    if (genere == null) {
      return getLibri(); // Restituisco tutti i libri se il genere è null
    }
    return cerca((libro) => libro.genere == genere);
  }

  /// Restituisce i libri in base allo stato specificato.
  /// Se [stato] è null, restituisce tutti i libri.
  List<Libro> getLibriPerStato(StatoLibro? stato) {
    if (stato == null) {
      return getLibri(); // Restituisco tutti i libri se lo stato è null
    }
    return cerca((libro) => libro.stato == stato);
  }

  /// Metodo helper per il filtraggio combinato dei libri.
  /// Permette di filtrare per genere, stato, preferiti e titolo contemporaneamente.
  List<Libro> getLibriFiltrati({
    GenereLibro? genere,
    StatoLibro? stato,
    bool soloPreferiti = false,
    String? titolo,
  }) {
    final filtrati = cerca((libro) {
      // Il metodo cerca() prende in input una Function (una funzione di filtraggio) che restituisce un bool
      // 
      final genereOk = genere == null || libro.genere == genere;
      final statoOk = stato == null || libro.stato == stato;
      final preferitiOk = !soloPreferiti || libro.preferito;
      final titoloOk =
          titolo == null ||
          libro.titolo.toLowerCase().contains(titolo.toLowerCase());
      return genereOk && statoOk && preferitiOk && titoloOk;
    });

    // Ordino i risultati per titolo
    filtrati.sort((libro1, libro2) => libro1.titolo.toLowerCase().compareTo(libro2.titolo.toLowerCase()));
    return filtrati;
  }

  /// Restituisce tutti i libri come lista ordinata alfabeticamente per titolo.
  List<Libro> getLibriOrdinati() {
   final libri = _libri.values.toList();
    libri.sort((libro1, libro2) => libro1.titolo.toLowerCase().compareTo(libro2.titolo.toLowerCase()));
    return libri;
  }

  /// Restituisce tutti i libri come lista non ordinata.
  List<Libro> getLibri() {
    return _libri.values.toList();
  }
}
