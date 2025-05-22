import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../models/libro.dart';
import '../../services/apis/google_books_api.dart';
import '../../models/libreria.dart'; // Importa la tua classe Libreria

class RicercaGoogleBooksController {
  final TextEditingController searchQueryController = TextEditingController();
  final BookApiService _apiService = BookApiService();
  final Libreria _libreria = Libreria(); // Ottieni l'unica istanza della Libreria

  // Variabile contenente tutti i libri restituiti dall'API per una ricerca
  List<Libro> _searchResults = [];
  bool _isLoading = false;
  VoidCallback? _onUpdate;
  Function(String message, {bool isError})? _onShowMessage;

  List<Libro> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  void addListener(VoidCallback listener) { _onUpdate = listener; }
  void removeListener() { _onUpdate = null; }
  void addMessageListener(Function(String message, {bool isError}) listener) { _onShowMessage = listener; }
  void removeMessageListener() { _onShowMessage = null; }

  void _notifyListeners() { _onUpdate?.call(); }
  void _showMessage(String message, {bool isError = false}) { _onShowMessage?.call(message, isError: isError); }

  Future<void> searchBooks() async {
    final String query = searchQueryController.text.trim();
    if (query.isEmpty) {
      _searchResults = [];
      _notifyListeners();
      return;
    }

    _isLoading = true;
    _searchResults = [];
    _notifyListeners();

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
        _showMessage('Nessun libro trovato per la tua ricerca.', isError: false);
      }
    } catch (e) {
      debugPrint('Errore durante la ricerca su Google Books: $e');
      _searchResults = [];
      _showMessage('Errore durante la ricerca: ${e.toString()}', isError: true);
    } finally {
      _isLoading = false;
      _notifyListeners();
    }
  }

  // QUESTO è il metodo handleAggiungi rilevante per questo controller
  // che prende un Libro GIA' FORMATO dall'API
  Future<void> handleAggiungi(Libro libro) async {
    // Il libro 'libro' qui è già stato creato dal factory Libro.fromGoogleBooksJson
    // e ha già tutte le sue proprietà parsate (titolo, autori, isbn, ecc.).
    // Non abbiamo TextEditingController da leggere qui.

    try {
      // Controlla se il libro è già presente in libreria usando l'ISBN
      if (_libreria.cercaLibroPerIsbn(libro.isbn) != null) {
        _showMessage('"${libro.titolo}" è già presente nella tua libreria.', isError: true);
        debugPrint('Libro "${libro.titolo}" (ISBN: ${libro.isbn}) già presente.');
        return; // Non fare nulla se il libro è un duplicato
      }

      // Aggiungi il libro alla tua collezione in memoria (gestita dal Singleton Libreria)
      _libreria.aggiungiLibro(libro);

      debugPrint('Libro "${libro.titolo}" (ISBN: ${libro.isbn}) aggiunto con successo alla Libreria.');
      _showMessage('"${libro.titolo}" aggiunto alla tua libreria!', isError: false);

    } catch (e) {
      // Cattura eventuali eccezioni che _libreria.aggiungiLibro potrebbe lanciare
      // (es. se avessi introdotto una validazione interna che lancia errori)
      debugPrint('Errore nell\'aggiunta del libro "${libro.titolo}" alla Libreria: $e');
      _showMessage('Errore durante l\'aggiunta di "${libro.titolo}": ${e.toString()}', isError: true);
    }
    // Dato che _libreria.aggiungiLibro è sincrono, non è necessario un indicatore _isLoading qui.
  }

  void dispose() {
    searchQueryController.dispose();
    _onUpdate = null;
    _onShowMessage = null;
  }
}