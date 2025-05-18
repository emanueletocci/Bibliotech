/*
 * Questo file contiene l'implementazione della logica di business per l'intera libreria...
 * nonché la mappa che a runtime contiene tutti i libri e le loro informazioni.
*/

import '../models/libro.dart';

class LibreriaService {
  // struttura dati che contiene l'insieme di libri a runtime
  // I libri vengono ulteriormente salvati in un database all'uscita dall'app

  Map<String, Libro> _libri = {}; // chiave: isbn, valore: libro... in questo modo i duplicati sono gestiti automaticamente

  // Metodo per ottenere il numero totale di libri presenti in libreria
  int get numeroTotaleLibri => _libri.length; 
  // get é una keyword in dart che consente di implementare un getter. 
  // Si accede come una proprietà, senza doverla chiamare come un metodo.

  // Consente l'aggiunta di un libro alla libreria
  void aggiungiLibro(Libro libro) {
    if (libro.isbn.isNotEmpty) {
      _libri[libro.isbn] = libro;
    } else {
      throw Exception("ISBN non valido");
    }
  }

  // Consente la rimozione di un libro specificando l'ISBN
  void rimuoviLibro(String isbn) {
    if (_libri.containsKey(isbn)) {
      _libri.remove(isbn);
    } else {
      throw Exception("ISBN non trovato");
    }
  }

  // Consente la modifica di un libro presente in libreria
  void modificaLibro(String isbn, Libro libro) {
    if (_libri.containsKey(isbn)) {
      _libri[isbn] = libro;
    } else {
      throw Exception("ISBN non trovato");
    }
  }

  // Consente di cercare un libro specifico tramite il nome (case insensitive)
  Libro? cercaLibroPerNome(String nome) {
    for (var libro in _libri.values) {
      if (libro.titolo.toLowerCase().contains(nome.toLowerCase())) {
        return libro;
      }
    }
    return null;
  }

  // Consente di cercare un libro specifico tramite l'ISBN
  Libro? cercaLibroPerIsbn(String isbn) {
    return _libri[isbn];
  }

  // Ricerca generica (NON SO SE LASCIARLA) tramite callback
  List<Libro> cerca(bool Function(Libro) criterio) {
    return _libri.values.where(criterio).toList();
  }

  // Ottengo tutti i libri presenti in libreria sotto forma di lista
  List<Libro> getLibri() {
    return _libri.values.toList();
  }

}
