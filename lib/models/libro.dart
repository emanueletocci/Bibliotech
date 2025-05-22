import 'genere_libro.dart';
import 'stato_libro.dart';

class Libro {
  String titolo;
  List<String>? autori;
  int? numeroPagine;
  GenereLibro? genere; // Dovrai decidere come mappare i generi di Google Books ai tuoi
  String? lingua;
  String? trama;
  String isbn; // O isbn10 o isbn13, deciderai quale usare come 'primario'
  DateTime? dataPubblicazione;
  double? voto;
  String? copertina; // conterrà il percorso locale dell'immagine o un percorso di rete
  String? note;
  StatoLibro? stato;

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
  });

  // Factory constructor per creare un oggetto Libro da una risposta JSON di Google Books API
  factory Libro.fromGoogleBooksJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] as Map<String, dynamic>?;
    final imageLinks = volumeInfo?['imageLinks'] as Map<String, dynamic>?;
    final industryIdentifiers = volumeInfo?['industryIdentifiers'] as List<dynamic>?;

    String? foundIsbn10;
    String? foundIsbn13;
    if (industryIdentifiers != null) {
      for (var identifier in industryIdentifiers) {
        if (identifier['type'] == 'ISBN_10') {
          foundIsbn10 = identifier['identifier'];
        } else if (identifier['type'] == 'ISBN_13') {
          foundIsbn13 = identifier['identifier'];
        }
      }
    }

    DateTime? parsedDate;
    if (volumeInfo?['publishedDate'] != null) {
      try {
        // L'API di Google Books può restituire date in diversi formati (es. "2006", "2006-01-01")
        // Potrebbe essere necessario un parsing più robusto o un pacchetto come 'intl'
        parsedDate = DateTime.tryParse(volumeInfo!['publishedDate']);
      } catch (e) {
        print('Errore nel parsing della data: ${volumeInfo!['publishedDate']} - $e');
      }
    }

    return Libro(
      // Il titolo è richiesto, quindi usiamo un fallback se non presente dall'API (anche se improbabile)
      titolo: volumeInfo?['title'] as String? ?? 'Titolo Sconosciuto',
      autori: (volumeInfo?['authors'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      numeroPagine: volumeInfo?['pageCount'] as int?,
      // genere: mappedGenere, // Applica la mappatura del genere
      lingua: volumeInfo?['language'] as String?,
      trama: volumeInfo?['description'] as String?,
      // L'ISBN è richiesto nel tuo modello. Usiamo ISBN-13 se disponibile, altrimenti ISBN-10, altrimenti un fallback vuoto.
      isbn: foundIsbn13 ?? foundIsbn10 ?? '',
      dataPubblicazione: parsedDate,
      // Voto, Note, Stato non sono forniti dall'API, quindi li lasciamo a null
      voto: null,
      note: null,
      stato: null,
      // Usiamo l'URL della thumbnail come 'copertina' per l'API.
      // Se vuoi salvarla localmente, dovrai scaricarla separatamente.
      copertina: imageLinks?['thumbnail'] as String?,
    );
  }
}