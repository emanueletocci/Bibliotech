import 'package:flutter/material.dart';

import '../../models/libro.dart';
import '../../services/apis/google_books_api.dart';
import '../../models/libreria.dart';

class RicercaGoogleBooksController {
  final TextEditingController searchQueryController = TextEditingController();
  final BookApiService _apiService = BookApiService();
  final Libreria _libreria = Libreria(); 

  // Variabile contenente tutti i libri restituiti dall'API per una ricerca
  List<Libro> _searchResults = [];
  bool _isLoading = false;


  List<Libro> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  Future<void> searchBooks() async {
    final String query = searchQueryController.text.trim();
    if (query.isEmpty) {
      _searchResults = [];
      return;
    }

    _isLoading = true;
    _searchResults = [];

    try {
      final RegExp isbn13Regex = RegExp(r'^(?:ISBN(?:-13)?:?\s*(?=[0-9]{13}$))((978|979)[0-9]{10}|[0-9]{13})$');
      final RegExp isbn10Regex = RegExp(r'^(?:ISBN(?:-10)?:?\s*(?=[0-9X]{10}$))([0-9]{9}[0-9X])$');
      final String cleanQuery = query.replaceAll('-', '');

      List<Libro> results;
      if (isbn13Regex.hasMatch(cleanQuery) || isbn10Regex.hasMatch(cleanQuery)) {
        debugPrint('DEBUG: Ricerca per ISBN: $query');
        results = await _apiService.searchBooks(isbn: cleanQuery);
      } else {
        debugPrint('DEBUG: Ricerca per query generica: $query');
        results = await _apiService.searchBooks(query: query);
      }
      _searchResults = results;
      if (results.isEmpty) {
        throw Exception('Nessun libro trovato per la tua ricerca.'); 
      }
    } catch (e) {
      debugPrint('Errore durante la ricerca su Google Books: $e');
      _searchResults = [];
      // Rilancio l'eccezione per gestirla a livello di UI
      throw Exception('Errore durante la ricerca: ${e.toString()}'); 
    } finally {
      _isLoading = false;
    }
  }

  // Metodo per gestire l'aggiunta del libro alla libreria. Il metodo prende in input un oggetto Libro fornito dall'API
  void handleAggiungi(Libro libro) {
    // Il libro 'libro' è stato creato dal factory Libro.fromGoogleBooksJson
    try {
      // Controllo se il libro è già presente in libreria 
      if (_libreria.cercaLibroPerIsbn(libro.isbn) != null) {
        throw Exception('Il libro è già presente nella libreria!');
      }
      _libreria.aggiungiLibro(libro);

      debugPrint('Libro "${libro.titolo}" (ISBN: ${libro.isbn}) aggiunto con successo alla Libreria.');

    } catch (e) {
      debugPrint('Errore durante l\'aggiunta di "${libro.titolo}": ${e.toString()}');
    }
  }

}