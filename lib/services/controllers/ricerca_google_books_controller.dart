/*
 * Questo controller gestisce la ricerca di libri tramite l'API di Google Books, nella relativa schermata di ricerca.
 * L'aggiunta e i relativi controlli sono stati delegati ad un altro controller
 */
import 'package:flutter/material.dart';
import 'package:isbn/isbn.dart';

import '../../models/libro_model.dart';
import '../apis/google_books_api.dart';

/// Controller per la ricerca di libri tramite l'API di Google Books.
/// Gestisce la logica di ricerca e lo stato dei risultati.
class RicercaGoogleBooksController {
  /// Controller per il campo di testo della query di ricerca.
  final TextEditingController searchQueryController = TextEditingController();

  /// Servizio per le chiamate all'API di Google Books.
  final BookApiService _apiService = BookApiService();

  /// Validatore per codici ISBN.
  final Isbn isbnValidator = Isbn();

  // Il controller prende in input la libreria fornita dalla vista tramite il Provider
  RicercaGoogleBooksController();

  // Variabile contenente tutti i libri restituiti dall'API per una ricerca
  List<Libro> _searchResults = [];
  bool _isLoading = false;

  /// Risultati della ricerca corrente.
  List<Libro> get searchResults => _searchResults;

  /// Stato di caricamento della ricerca.
  bool get isLoading => _isLoading;

  // Metodo per la ricerca dei libri tramite l'API di Google Books mediante il textFiedl presente
  // nella schermata di aggiunta tramite API. il metodo prende in input una stringa di ricerca (isbn o titolo)
  // ed effettua una chiamata all'API per ottenere i risultati.

  /// Esegue la ricerca di libri tramite l'API di Google Books.
  /// Utilizza il testo inserito dall'utente come query (ISBN o titolo).
  /// Aggiorna lo stato di caricamento e i risultati della ricerca.
  /// Lancia un'eccezione se si verifica un errore o se non vengono trovati libri.
  Future<void> searchBooks() async {
    final String query = searchQueryController.text.trim();
    if (query.isEmpty) {
      _searchResults = [];
      return;
    }

    _isLoading = true;
    _searchResults = [];

    // Provo ad effettuare la ricerca tramite l'API
    try {
      // Se il testo inserito dall'utente non é un isbn
      if (isbnValidator.notIsbn(query, strict: false)) {
        debugPrint('DEBUG: Ricerca per titolo: $query');
        _searchResults = await _apiService.searchBooks(query: query);
      } else {
        // Se il testo inserito dall'utente é un isbn, lo pulisco e lo uso per la ricerca
        String cleanQuery = isbnValidator.toCanonical(query);
        debugPrint('DEBUG: Ricerca per ISBN: $cleanQuery');
        _searchResults = await _apiService.searchBooks(isbn: cleanQuery);
      }

      if (_searchResults.isEmpty) {
        throw Exception('Nessun libro trovato per la tua ricerca.');
      }
    } catch (e) {
      debugPrint('Errore durante la ricerca su Google Books: $e');
      _searchResults = [];
      // Rilancio l'eccezione per gestirla a livello di UI
      throw Exception('Errore durante la ricerca:');
    } finally {
      _isLoading = false;
    }
  }
}
