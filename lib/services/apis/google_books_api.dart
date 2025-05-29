import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/libro_model.dart';
import 'package:flutter/foundation.dart'; 

class BookApiService {
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';
  final String _apiKey = 'AIzaSyAS4UBcNyaopa--50IrAguJEgQ8yo4pq3A';

  Future<List<Libro>> searchBooks({String? query, String? isbn}) async {
    String searchParam = '';

    // Se é presente un ISBN, lo uso come parametro di ricerca, altrimenti uso la query
    if (isbn != null && isbn.isNotEmpty) {
      searchParam = 'isbn:$isbn';
    } else if (query != null && query.isNotEmpty) {
      searchParam = query;
    } else {
      return []; // Nessun parametro di ricerca valido
    }

    // https://www.googleapis.com/books/v1/volumes?q=isbn:....
    final url = '$_baseUrl?q=$searchParam&key=$_apiKey&maxResults=10';

    debugPrint('DEBUG API: Calling API: $url');

    try {
      final response = await http.get(Uri.parse(url));

      debugPrint('DEBUG API: Stato risposta: ${response.statusCode}');
      debugPrint('DEBUG API: Corpo risposta: ${response.body}');

      if (response.statusCode == 200) {
        // Con decode prendo la risposta JSON e la converto in una struttura nativa di Dart (una mappa)
        final Map<String, dynamic> data = json.decode(response.body);

        /* Struttura della risposta JSON
          {
            "kind": "books#volumes",
            "totalItems": 123,
            "items": [ // array contenente i libri trovati
              {
                "kind": "books#volume",
                "id": "...",
                "volumeInfo": { ... }, // Dettagli del libro
                // ... altri campi sul libro
              },
              {
                // ... un altro libro
              }
            ]
          }

        */

        // Accedo alla lista di libri trovati
        final List<dynamic>? items = data['items'];

        if (items != null && items.isNotEmpty) {
          // Mappa tutti gli elementi trovati in una lista di Libri
          return items.map((jsonItem) => Libro.fromGoogleBooksJson(jsonItem)).toList();
        } else {
          debugPrint('DEBUG API: Nessun elemento trovato nella risposta.');
        }
      } else {
        debugPrint('Errore API: ${response.statusCode}');
        debugPrint('Corpo della risposta: ${response.body}');
      }
    } catch (e) {
      debugPrint('Errore nella chiamata API (catch): $e');
    }
    return []; // Nessun libro trovato o errore, ritorna una lista vuota
  }
}