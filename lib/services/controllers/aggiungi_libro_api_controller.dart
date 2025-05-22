import 'package:flutter/material.dart';
import '../../models/libro.dart';
import '../../services/apis/google_books_api.dart';

class RicercaGoogleBooksController {
  final TextEditingController searchQueryController = TextEditingController();
  final BookApiService _apiService = BookApiService();

  List<Libro> _searchResults = [];
  bool _isLoading = false;
  VoidCallback? _onUpdate; // Callback per notificare la UI

  // Getters per accedere allo stato
  List<Libro> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  // Metodi per la notifica della UI
  void addListener(VoidCallback listener) {
    _onUpdate = listener;
  }

  void removeListener() {
    _onUpdate = null;
  }

  void _notifyListeners() {
    _onUpdate?.call();
  }

  // Logica di ricerca
  Future<void> searchBooks() async {
    final String query = searchQueryController.text.trim();
    if (query.isEmpty) {
      _searchResults = [];
      _notifyListeners();
      return;
    }

    _isLoading = true;
    _searchResults = []; // Pulisce i risultati precedenti
    _notifyListeners();

    try {
      // Determina se la query è un ISBN o un titolo/autore
      List<Libro> results;
      if (RegExp(r'^(?:ISBN(?:-13)?:?)(?=[0-9]{13}$)\d{3}-?\d{1}-?\d{3}-?\d{5}-?[\dxX]$')
          .hasMatch(query) ||
          RegExp(r'^(?:ISBN(?:-10)?:?)(?=[0-9]{10}$)\d{1}-?\d{3}-?\d{5}-?[\dxX]$')
              .hasMatch(query)) {
        results = await _apiService.searchBooks(isbn: query);
      } else {
        results = await _apiService.searchBooks(query: query);
      }
      _searchResults = results;
    } catch (e) {
      print('Errore durante la ricerca su Google Books: $e');
      _searchResults = []; // In caso di errore, resetta i risultati
      // TODO: Mostra un messaggio di errore all'utente (es. SnackBar)
    } finally {
      _isLoading = false;
      _notifyListeners();
    }
  }

  // Metodo per pulire le risorse del controller
  void dispose() {
    searchQueryController.dispose();
  }
}