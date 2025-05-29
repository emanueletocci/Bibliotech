import 'genere_libro.dart';
import 'stato_libro.dart';

class Libro {
  String titolo;
  List<String>? autori;
  int? numeroPagine;
  GenereLibro? genere; 
  String? lingua;
  String? trama;
  String isbn;
  DateTime? dataPubblicazione;
  double? voto;
  String? copertina; // conterrà il percorso locale dell'immagine locale o un percorso di rete
  String? note;
  StatoLibro? stato;
  String? publisher;
  bool preferito;

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
    this.preferito = false, // Imposto preferito a false di default
  });

  /* FORMATO API LIBRO GOOGLE BOOKS
    {
    "kind": "books#volume",
    "id": "...",
    "volumeInfo": { // <--- Contiene le informazioni principali del libro
      "title": "Il Signore degli Anelli",
      "authors": ["J.R.R. Tolkien"],
      "publisher": "...",
      "publishedDate": "1954", // Può essere solo l'anno, o una data completa
      "description": "...",
      "industryIdentifiers": [ // <--- Contiene gli ISBN
        { "type": "ISBN_10", "identifier": "0345339681" },
        { "type": "ISBN_13", "identifier": "9780345339683" }
      ],
      "pageCount": 1216,
      "imageLinks": { // <--- Contiene gli URL delle copertine
        "smallThumbnail": "http://...",
        "thumbnail": "http://..."
      },
      "language": "en",
      // ... altri campi
    },
    // ... altri campi di primo livello che non ci interessano
    }
  */

  // Metodo per ottenere una stringa formattata degli autori
  String getAutoriString() {
    if (autori != null && autori!.isNotEmpty) {
      return autori!.join(', ');
    }
    return "Autori sconosciuti";
  }

  // Metodo per ottenere una stringa formattata delle note inserite dall'utente
  String getNoteString() {
    if (note == null || note!.isEmpty) {
      return "Nessuna nota disponibile";
    }
    return note!;
  }

  //  -- Metodi necessari per SQLite --

  Map<String, dynamic> toMap() {
    return {
      'isbn': isbn,
      'titolo': titolo,
      'autori': autori?.join(
        ',',
      ), // Salva la lista come stringa separata da virgole
      'numeroPagine': numeroPagine,
      'genere':
          genere
              ?.toString(), // Prelevo direttamente il 'titolo' dell'enumerazione
      'lingua': lingua,
      'trama': trama,
      'dataPubblicazione': dataPubblicazione?.toIso8601String(),
      'voto': voto,
      'copertina': copertina,
      'note': note,
      'stato':
          stato
              ?.toString(), // Prelevo direttamente il 'titolo' dell'enumerazione
      'publisher': publisher,
      'preferito':
          preferito ? 1 : 0, // SQLite non ha booleani, quindi devo usare interi
    };
  }

  // Factory constructor per creare un oggetto Libro da una mappa
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

  // -- Metodi necessari per l'API --

  // Factory constructor per creare un oggetto Libro da una risposta JSON di Google Books API
  factory Libro.fromGoogleBooksJson(Map<String, dynamic> json) {
    // Accedo alla chiave 'volumeInfo' come mappa per ottenere le informazioni principali del libro
    // 'as' é l'operatore di cast di dart, con as Tipo? si usa il cast sicuro
    // cerco di trattare i dati all'interno di volumeInfo come una mappa, se non riesco a farlo, volumeInfo sarà null
    final volumeInfo = json['volumeInfo'] as Map<String, dynamic>?;

    // Accedo alla chiave 'imageLinks' per ottenere le informazioni sulle copertine
    final imageLinks = volumeInfo?['imageLinks'] as Map<String, dynamic>?;

    // Accedo alla chiave 'categories' per ottenere le categorie del libro scelto
    final List<dynamic>? categories =
        volumeInfo?['categories'] as List<dynamic>?;
    GenereLibro? genere;

    if (categories != null && categories.isNotEmpty) {
      // Prendo le prime 3 categorie e cerco le corrispondenze
      final categorieDaControllare =
          categories.take(3).map((c) => c.toString().toLowerCase()).toList();
      // Cerca la prima corrispondenza valida tra le categorie
      for (final categoria in categorieDaControllare) {
        genere = _mapCategoriaToGenere(categoria);
        if (genere != null) {
          break; // Se trovo corrispondenza, esco direttamente
        }
      }
    }

    return Libro(
      // ?? é l'operatore if-null di dart... se il cast sicuro fallisce, allora imposto il titolo a 'Titolo Sconosciuto'
      // In questo modo il titolo non sarà mai null
      titolo: volumeInfo?['title'] as String? ?? 'Titolo Sconosciuto',
      genere: genere,
      // Chiamiamo il metodo statico _parseAuthors per estrarre e pulire la lista degli autori
      autori: _parseAuthors(volumeInfo),

      numeroPagine: volumeInfo?['pageCount'] as int?,

      // genere: mappedGenere, // Applica la mappatura del genere (questo rimane a tua discrezione)
      lingua: volumeInfo?['language'] as String?,
      trama: volumeInfo?['description'] as String?,
      publisher: volumeInfo?['publisher'] as String?,

      isbn: _parseIsbn(volumeInfo),

      dataPubblicazione: _parsePublishedDate(volumeInfo),

      // Voto, Note, Stato non sono forniti dall'API, quindi li inizializzo a null
      // Sará poi l'utente a modificarli manualmente
      voto: null,
      note: null,
      stato: null,

      copertina: imageLinks?['thumbnail'] as String?,
    );
  }


  // Metodo statico per mappare le categorie di Google Books ai generi interni definiti nell'app
  static GenereLibro? _mapCategoriaToGenere(String categoria) {
    categoria = categoria.toLowerCase();

    // Mappa di corrispondenza tra sottostringhe e generi
    // Provo a mappare le categorie di Google Books principali ai generi definiti nell'app
    // Sicuramente qualche categoria non sarà presente, quindi ritorno null. In tal caso l'utente
    // dovrá impostare manualmente il genere del libro

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
      // controllo se la key contiene almeno una delle sottostringhe della categoria
      // Eg. categoria = "science fiction adventure"; entry.key = ['science fiction', 'sci-fi']
      // Eg. Restituisco true perché categoria contiene 'science fiction'
      if (entry.key.any((k) => categoria.contains(k))) {
        return entry.value;
      }
    }
    return GenereLibro.noCategoria; // Se non trovo corrispondenza, imposto a "Nessuna Categoria"
  }

  // Metodo statico per il parsing degli autori
  static List<String>? _parseAuthors(Map<String, dynamic>? volumeInfo) {
    // Se volumeInfo è null, non ci sono autori da estrarre
    if (volumeInfo == null) return null;

    // Accedo alla chiave 'authors' per ottenere la lista degli autori.
    // Provo a castare come List<dynamic>? per sicurezza
    final dynamic listaAutoriEstratti = volumeInfo['authors'] as List<dynamic>?;

    if (listaAutoriEstratti != null && listaAutoriEstratti is List) {
      // Mappa ogni elemento della lista a una stringa e la converte in List<String>
      // Ho controllato se listaAutoriEstratti é effettivamente una lista per evitare errori con la funzione di mapping
      return listaAutoriEstratti.map((e) => e.toString()).toList();
    }
    // Se non trovo autori o non sono nel formato corretto, ritorno null
    return null;
  }

  // Metodo statico per il parsing e la prioritizzazione degli ISBN
  static String _parseIsbn(Map<String, dynamic>? volumeInfo) {
    // Se volumeInfo è null, non ci sono ISBN da estrarre, quindi ritorno una stringa vuota come fallback
    if (volumeInfo == null) return '';

    // Accedo alla chiave 'industryIdentifiers' per ottenere gli ISBN
    // Provo a castare come List<dynamic>? per sicurezza
    final industryIdentifiers =
        volumeInfo['industryIdentifiers'] as List<dynamic>?;

    String? foundIsbn10;
    String? foundIsbn13;

    if (industryIdentifiers != null) {
      // Scorro ogni identificatore nella lista
      for (var identifier in industryIdentifiers) {
        // Effettuo un controllo più robusto: l'identificatore deve essere una mappa
        // e deve contenere le chiavi 'type' e 'identifier'
        if (identifier is Map<String, dynamic> &&
            identifier.containsKey('type') &&
            identifier.containsKey('identifier')) {
          // Se il tipo è 'ISBN_10', salvo il suo valore nella variabile foundIsbn10
          if (identifier['type'] == 'ISBN_10') {
            foundIsbn10 = identifier['identifier'] as String?;
          }
          // Se il tipo è 'ISBN_13', salvo il suo valore nella variabile foundIsbn13
          else if (identifier['type'] == 'ISBN_13') {
            foundIsbn13 = identifier['identifier'] as String?;
          }
        }
      }
    }
    // Restituisco l'ISBN-13 se trovato, l'ISBN-10, altrimenti una stringa vuota
    // ISBN-13 ha la priorità su ISBN-10
    return foundIsbn13 ?? foundIsbn10 ?? '';
  }

  // Metodo statico per il parsing della data di pubblicazione
  static DateTime? _parsePublishedDate(Map<String, dynamic>? volumeInfo) {
    if (volumeInfo == null) return null;

    final String? publishedDateString = volumeInfo['publishedDate'] as String?;
    if (publishedDateString != null) {
      try {
        return publishedDateString.length > 4
            ? DateTime.parse(publishedDateString)
            : DateTime(
              int.parse(publishedDateString),
              1,
              1,
            ); // Se la data è solo l'anno, restituisco il primo gennaio di quell'anno
      } catch (_) {
        return null; // Se il parsing fallisce, ritorna null
      }
    }
    return null;
  }
}
