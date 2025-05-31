import '../../../models/genere_libro_model.dart';
import '../../../models/stato_libro_model.dart';
import 'package:isbn/isbn.dart';

/// Classe astratta base per i controller di aggiunta e modifica libro.
/// Fornisce proprietà comuni e metodi di validazione per i dati del libro.
abstract class GenericController {
  /// Validatore per codici ISBN.
  final Isbn isbnValidator = Isbn();

  /// Genere selezionato per il libro.
  GenereLibro? genereSelezionato;

  /// Stato selezionato per il libro.
  StatoLibro? statoSelezionato;

  /// Titolo del libro.
  String titolo = '';

  /// Lista degli autori del libro.
  List<String>? autori;

  /// Numero di pagine del libro.
  int? numeroPagine;

  /// Lingua del libro.
  String? lingua;

  /// Trama del libro.
  String? trama;

  /// Codice ISBN del libro.
  String isbn = '';

  /// Data di pubblicazione del libro.
  DateTime? dataPubblicazione;

  /// Voto assegnato al libro.
  double? voto;

  /// Percorso della copertina del libro.
  String copertina = 'assets/images/book_placeholder.jpg';

  /// Note aggiuntive sul libro.
  String? note;

  /// Stato del libro (letto, da leggere, ecc.).
  StatoLibro? stato;

  /// Genere del libro.
  GenereLibro? genere;

  /// Indica se il libro è segnato come preferito.
  /// Impostato a false di default.
  bool isPreferito = false;

  /// Controlla la validità dei campi principali del libro.
  /// Lancia un'eccezione se il titolo è vuoto o l'ISBN non è valido.
  /// Restituisce true se i campi sono validi.
  bool controllaCampiObbligatori() {
    if (titolo.isEmpty) {
      throw Exception("Il titolo non può essere vuoto");
    }

    // Controllo se l'isbn inserito é valido
    if (isbnValidator.notIsbn(isbn, strict: false)) {
      throw Exception("L'ISBN inserito non è valido");
    }

    return true;
  }

  /// Controlla i campi facoltativi del libro e restituisce un messaggio di avviso se necessario, altrimenti null.
  String? controllaCampiFacoltativi() {
    final StringBuffer messaggio = StringBuffer();
    if(stato == null) {
      messaggio.write("Stato non selezionato! Si consiglia di inserire manualmente uno stato!\n\n");
    }

    if(genere == null) {
      // Teoricamente, se la mappatura del genere funziona correttamente, il genere non dovrebbe essere mai null.
      messaggio.write("Genere non selezionato! Si consiglia di inserire manualmente un genere!\n\n");
    }

    if(voto!=null){
      if(voto! < 0 || voto! > 5) {
        messaggio.write("Il voto deve essere compreso tra 0 e 10! Verrá normalizzato automaticamente\n\n");
      }
    }

    return messaggio.isNotEmpty ? messaggio.toString() : null;
  }

  /// Metodo astratto per gestire l'aggiunta di un libro.
  /// Deve essere implementato dalle classi figlie.
  handleAggiungiLibro();
}
