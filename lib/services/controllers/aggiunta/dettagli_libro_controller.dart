/*
 * Il controller in questione gestisce l'aggiunta e l'eliminazione dei libri già presenti nella libreria. Il controller infatti
 * prende in input un libro giá pronto (magari fornito dall'api o semplicemente giá presnete in libreria) e gestisce la sua
 * aggiunta o elimainazione, effettuando i dovuti controlli sui campi del libro.
 */

import 'package:bibliotech/services/controllers/aggiunta/aggiunta_base_controller.dart';
import '../../../models/libreria.dart';
import '../../../models/libro.dart';

class DettagliLibroController extends GenericController{

  // La libreria é ottenuta dalla view tramite il provider
  final Libreria _libreria;
  final Libro? _libroVisualizzato;

  DettagliLibroController(this._libreria, this._libroVisualizzato): super();

  // Metodo helper che consente di ottenere i dati grezzi da un libro giá esistente
  void _getFromLibro(){
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

  @override
  void handleAggiungiLibro(){
    // Ottengo i dati dal libro visualizzato, se presente in modo tale da poter controllare se sono validi, prima di aggiungerli
    _getFromLibro();
    if(!controllaCampi()) return;

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
  }

  void handleRimuoviLibro() {
    if (_libroVisualizzato != null) {
      _libreria.rimuoviLibro(_libroVisualizzato);
    } else {
      throw Exception("Nessun libro da rimuovere");
    }
  }

  @override
  bool controllaCampi() {
    bool status = super.controllaCampi();

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