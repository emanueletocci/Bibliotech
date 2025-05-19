import 'libro.dart';

class Libreria {
  // Implementazione del Singleton: il pattern consente di avere una sola istanza della libreria, accessibile da qualsiasi parte dell'app
  // https://medium.com/@swe.jamirulinfo/singleton-is-a-design-pattern-in-dart-98dd947c6dd1

  static final Libreria _instance =
      Libreria._privateConstructor(); // si usa il named constructor 'internal'

  // chiamata al costruttore factory che restituisce l'istanza precedentemente creata
  // chiamando Libreria() in qualsiasi parte dell'app, si ottiene sempre la stessa istanza, mediante tale costruttore

  factory Libreria() => _instance;

  // Definizione del costruttore privato 'internal'
  Libreria._privateConstructor();

  // struttura dati che contiene l'insieme di libri a runtime
  // I libri vengono ulteriormente salvati in un database all'uscita dall'app
  final Map<String, Libro> _libri =
      {}; // chiave: isbn, valore: libro... in questo modo i duplicati sono gestiti automaticamente

  // Metodo per ottenere il numero totale di libri presenti in libreria
  int get numeroTotaleLibri => _libri.length;

  // get é una keyword in dart che consente di implementare un getter.
  // Si accede come una proprietà, senza doverla chiamare come un metodo.

  // Consente l'aggiunta di un libro alla libreria
  void aggiungiLibro(Libro libro) {
    // Il controllo sui campi é stato delegato al controller
    _libri[libro.isbn] = libro;
  
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
