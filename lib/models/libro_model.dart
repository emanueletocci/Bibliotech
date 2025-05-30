import 'genere_libro_model.dart';
import 'stato_libro_model.dart';

/// Rappresenta un libro all'interno dell'app.
/// Contiene tutte le informazioni rilevanti come titolo, autori, ISBN, genere, stato e altro.
class Libro {
  /// Titolo del libro.
  String titolo;

  /// Lista degli autori del libro.
  List<String>? autori;

  /// Numero totale di pagine del libro.
  int? numeroPagine;

  /// Genere del libro, basato su un'enumerazione personalizzata.
  GenereLibro? genere;

  /// Lingua in cui è scritto il libro.
  String? lingua;

  /// Trama o descrizione del libro.
  String? trama;

  /// Codice ISBN identificativo del libro (può essere ISBN-10 o ISBN-13).
  String isbn;

  /// Data di pubblicazione del libro.
  DateTime? dataPubblicazione;

  /// Valutazione (voto) assegnata al libro.
  double? voto;

  /// Percorso dell'immagine di copertina del libro (locale o URL di rete).
  String? copertina;

  /// Note personali inserite dall’utente.
  String? note;

  /// Stato di lettura del libro (ad esempio: da leggere, in lettura, letto).
  StatoLibro? stato;

  /// Casa editrice del libro.
  String? publisher;

  /// Indica se il libro è stato marcato come preferito.
  bool preferito;

  /// Costruttore per creare un oggetto [Libro] con le informazioni principali.
  Libro({
    required this.titolo,
    this.autori,
    this.numeroPagine,
    this.genere,
    this.lingua,
    this.trama,
    required this.isbn,
    this.dataPubblicazione,
    this.voto,
    this.copertina,
    this.note,
    this.stato,
    this.publisher,
    this.preferito = false,
  });

  /// Restituisce una stringa formattata contenente gli autori, oppure
  /// "Autori sconosciuti" se la lista è vuota o nulla.
  String getAutoriString() {
    if (autori != null && autori!.isNotEmpty) {
      return autori!.join(', ');
    }
    return "Autori sconosciuti";
  }

  /// Restituisce la nota salvata o un messaggio predefinito se non è presente.
  String getNoteString() {
    if (note == null || note!.isEmpty) {
      return "Nessuna nota disponibile";
    }
    return note!;
  }

  /// Converte l'oggetto [Libro] in una mappa, utile per la memorizzazione in SQLite.
  Map<String, dynamic> toMap() {
    return {
      'isbn': isbn,
      'titolo': titolo,
      'autori': autori?.join(','),
      'numeroPagine': numeroPagine,
      'genere': genere?.toString(),
      'lingua': lingua,
      'trama': trama,
      'dataPubblicazione': dataPubblicazione?.toIso8601String(),
      'voto': voto,
      'copertina': copertina,
      'note': note,
      'stato': stato?.toString(),
      'publisher': publisher,
      'preferito': preferito ? 1 : 0,
    };
  }

  /// Costruisce un oggetto [Libro] a partire da una mappa, tipicamente estratta da SQLite.
  factory Libro.fromMap(Map<String, dynamic> map) {
    return Libro(
      titolo: map['titolo'] as String,
      autori: (map['autori'] as String?)?.split(',').toList(),
      numeroPagine: map['numeroPagine'] as int?,
      genere:
          map['genere'] != null
              ? GenereLibro.values.firstWhere(
                (g) => g.toString() == map['genere'],
              )
              : null,
      lingua: map['lingua'] as String?,
      trama: map['trama'] as String?,
      isbn: map['isbn'] as String,
      dataPubblicazione:
          map['dataPubblicazione'] != null
              ? DateTime.parse(map['dataPubblicazione'] as String)
              : null,
      voto: (map['voto'] as num?)?.toDouble(),
      copertina: map['copertina'] as String?,
      note: map['note'] as String?,
      stato:
          map['stato'] != null
              ? StatoLibro.values.firstWhere(
                (s) => s.toString() == map['stato'],
              )
              : null,
      publisher: map['publisher'] as String?,
      preferito: (map['preferito'] as int?) == 1,
    );
  }

  /// Crea un oggetto [Libro] partendo da un JSON proveniente dalla Google Books API.
  factory Libro.fromGoogleBooksJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] as Map<String, dynamic>?;
    final imageLinks = volumeInfo?['imageLinks'] as Map<String, dynamic>?;
    final List<dynamic>? categories =
        volumeInfo?['categories'] as List<dynamic>?;
    GenereLibro? genere;

    if (categories != null && categories.isNotEmpty) {
      final categorieDaControllare =
          categories.take(3).map((c) => c.toString().toLowerCase()).toList();
      for (final categoria in categorieDaControllare) {
        genere = _mapCategoriaToGenere(categoria);
        if (genere != null) {
          break;
        }
      }
    }

    return Libro(
      titolo: volumeInfo?['title'] as String? ?? 'Titolo Sconosciuto',
      genere: genere,
      autori: _parseAuthors(volumeInfo),
      numeroPagine: volumeInfo?['pageCount'] as int?,
      lingua: volumeInfo?['language'] as String?,
      trama: volumeInfo?['description'] as String?,
      publisher: volumeInfo?['publisher'] as String?,
      isbn: _parseIsbn(volumeInfo),
      dataPubblicazione: _parsePublishedDate(volumeInfo),
      voto: null,
      note: null,
      stato: null,
      copertina: imageLinks?['thumbnail'] as String?,
    );
  }

  /// Mappa una stringa di categoria (proveniente da Google Books) a un valore [GenereLibro].
  /// Se nessuna corrispondenza è trovata, ritorna [GenereLibro.noCategoria].
  static GenereLibro? _mapCategoriaToGenere(String categoria) {
    categoria = categoria.toLowerCase();

    final mappaGeneri = {
      ['fantasy']: GenereLibro.fantasy,
      ['science fiction', 'sci-fi', 'sciencefiction', 'scifi']:
          GenereLibro.fantascienza,
      ['biography', 'biografia']: GenereLibro.biografia,
      ['poetry', 'poesia']: GenereLibro.poesia,
      ['thriller']: GenereLibro.thriller,
      ['horror']: GenereLibro.horror,
      ['mystery', 'crime', 'giallo']: GenereLibro.giallo,
      ['historical', 'storico', 'history']: GenereLibro.storico,
      ['classic', 'classico']: GenereLibro.classico,
      ['graphic novel', 'comics', 'fumetti', 'graphicnovel']:
          GenereLibro.graphicNovel,
      [
        'education',
        'instruction',
        'istruzione',
        'educational',
        'scuola',
        'computers',
      ]: GenereLibro.istruzione,
      ['fiction', 'romanzo', 'novel']: GenereLibro.romanzo,
      ['essay', 'non-fiction', 'saggio', 'nonfiction']: GenereLibro.saggio,
      ['children', 'bambini', 'ragazzi', 'kids', 'child']: GenereLibro.bambini,
      ['cooking', 'cucina', 'ricette', 'recipe']: GenereLibro.cucina,
      ['travel', 'viaggi', 'guide', 'travel guide']: GenereLibro.viaggi,
      ['art', 'arte', 'photography', 'fotografia']: GenereLibro.arte,
      ['health', 'salute', 'fitness', 'wellness']: GenereLibro.salute,
      ['business', 'economia', 'finance', 'finanza']: GenereLibro.economia,
    };

    for (final entry in mappaGeneri.entries) {
      if (entry.key.any((k) => categoria.contains(k))) {
        return entry.value;
      }
    }
    return GenereLibro.noCategoria;
  }

  /// Estrae e formatta la lista degli autori da `volumeInfo` della Google Books API.
  static List<String>? _parseAuthors(Map<String, dynamic>? volumeInfo) {
    if (volumeInfo == null) return null;

    final dynamic listaAutoriEstratti = volumeInfo['authors'] as List<dynamic>?;
    if (listaAutoriEstratti != null && listaAutoriEstratti is List) {
      return listaAutoriEstratti.map((e) => e.toString()).toList();
    }
    return null;
  }

  /// Estrae l'ISBN preferibilmente ISBN_13 da `volumeInfo`, se disponibile.
  static String _parseIsbn(Map<String, dynamic>? volumeInfo) {
    final identifiers = volumeInfo?['industryIdentifiers'] as List<dynamic>?;
    if (identifiers != null) {
      for (final id in identifiers) {
        if (id['type'] == 'ISBN_13') {
          return id['identifier'];
        }
      }
      for (final id in identifiers) {
        if (id['type'] == 'ISBN_10') {
          return id['identifier'];
        }
      }
    }
    return 'ISBN non disponibile';
  }

  /// Estrae e converte la data di pubblicazione da `volumeInfo`, se possibile.
  static DateTime? _parsePublishedDate(Map<String, dynamic>? volumeInfo) {
    final dateString = volumeInfo?['publishedDate'] as String?;
    if (dateString == null) return null;

    try {
      if (RegExp(r'^\d{4}$').hasMatch(dateString)) {
        return DateTime(int.parse(dateString));
      }
      return DateTime.parse(dateString);
    } catch (_) {
      return null;
    }
  }
}
