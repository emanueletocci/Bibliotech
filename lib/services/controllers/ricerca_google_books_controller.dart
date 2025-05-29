/*
 * Questo controller gestisce la ricerca di libri tramite l'API di Google Books, nella relativa schermata di ricerca.
 * L'aggiunta e i relativi controlli sono stati delegati ad un altro controller
 */
import 'package:flutter/material.dart';
import 'package:isbn/isbn.dart';

import '../../models/libro_model.dart';
import '../apis/google_books_api.dart';

class RicercaGoogleBooksController{
  final TextEditingController searchQueryController = TextEditingController();
  final BookApiService _apiService = BookApiService();
  final Isbn isbnValidator = Isbn();

  // Il controller prende in input la libreria fornita dalla vista tramite il Provider
  RicercaGoogleBooksController();

  // Variabile contenente tutti i libri restituiti dall'API per una ricerca
  List<Libro> _searchResults = [];
  bool _isLoading = false;

  List<Libro> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  // Metodo per la ricerca dei libri tramite l'API di Google Books mediante il textFiedl presente
  // nella schermata di aggiunta tramite API. il metodo prende in input una stringa di ricerca (isbn o titolo)
  // ed effettua una chiamata all'API per ottenere i risultati.
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
      if(isbnValidator.notIsbn(query, strict: false)) {
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
