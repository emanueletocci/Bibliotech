/*
 * Il controller in questione gestisce l'aggiunta e l'eliminazione dei libri già presenti nella libreria. Il controller infatti
 * prende in input un libro giá pronto (magari fornito dall'api o semplicemente giá presnete in libreria) e gestisce la sua
 * aggiunta o elimainazione, effettuando i dovuti controlli sui campi del libro.
 */

import 'package:bibliotech/services/controllers/aggiunta/aggiunta_base_controller.dart';
import '../../../models/libreria_model.dart';
import '../../../models/libro_model.dart';

/// Controller per la gestione dei dettagli di un libro.
/// Gestisce l'aggiunta e la rimozione di libri già presenti nella libreria.
/// Esegue controlli sui campi del libro prima di aggiungerlo o rimuoverlo.
class DettagliLibroController extends AggiuntaBaseController {
  /// Riferimento alla libreria gestita dal controller.
  final Libreria _libreria;

  /// Libro attualmente visualizzato o selezionato.
  final Libro? _libroVisualizzato;

  /// Costruttore che riceve la libreria e il libro da visualizzare.
  DettagliLibroController(this._libreria, this._libroVisualizzato) : super();

  /// Metodo helper che consente di ottenere i dati grezzi da un libro giá esistente.
  void _getFromLibro() {
    if (_libroVisualizzato != null) {
      titolo = _libroVisualizzato.titolo;
      autori = _libroVisualizzato.autori;
      numeroPagine = _libroVisualizzato.numeroPagine;
      lingua = _libroVisualizzato.lingua;
      trama = _libroVisualizzato.trama;
      isbn = _libroVisualizzato.isbn;
      dataPubblicazione = _libroVisualizzato.dataPubblicazione;
      voto = _libroVisualizzato.voto;
      copertina = _libroVisualizzato.copertina!;
      note = _libroVisualizzato.note;
      stato = _libroVisualizzato.stato;
      genere = _libroVisualizzato.genere;
      isPreferito = _libroVisualizzato.preferito;
    }
  }

  /// Gestisce l'aggiunta di un libro alla libreria dopo aver effettuato i controlli sui campi.
  @override
  String? handleAggiungiLibro() {
    // Ottengo i dati dal libro visualizzato, se presente in modo tale da poter controllare se sono validi, prima di aggiungerli
    _getFromLibro();
    if (!controllaCampiObbligatori()) return null;

    final avviso = controllaCampiFacoltativi();

    Libro nuovoLibro = Libro(
      titolo: titolo,
      autori: autori,
      numeroPagine: numeroPagine,
      genere: genere,
      lingua: lingua,
      trama: trama,
      isbn: isbn,
      dataPubblicazione: dataPubblicazione,
      voto: voto,
      copertina: copertina,
      note: note,
      stato: stato,
      preferito: isPreferito,
    );

    _libreria.aggiungiLibro(nuovoLibro);

    return avviso;
  }

  /// Gestisce la rimozione del libro attualmente visualizzato dalla libreria.
  /// Lancia un'eccezione se nessun libro è selezionato.
  void handleRimuoviLibro() {
    if (_libroVisualizzato != null) {
      _libreria.rimuoviLibro(_libroVisualizzato);
    } else {
      throw Exception("Nessun libro da rimuovere");
    }
  }

  /// Controlla la validità dei campi del libro prima di aggiungerlo.
  /// Verifica che non esista già un libro con lo stesso ISBN in libreria.
  /// Restituisce true se i campi sono validi, altrimenti lancia un'eccezione.
  @override
  bool controllaCampiObbligatori() {
    bool status = super.controllaCampiObbligatori();

    // Se il libro da visualizzare é presente, controllo che non esista già un libro con lo stesso ISBN
    if (_libroVisualizzato != null && isbn != _libroVisualizzato.isbn) {
      if (_libreria.cercaLibroPerIsbn(isbn) != null) {
        status = false;
        throw Exception("Il libro con questo ISBN è già presente in libreria");
      }
    }

    return status;
  }
}
