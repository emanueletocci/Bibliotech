// Implementazione del controller per la pagina di aggiunta libro
// Da decidere se implementare un controller differente per l'aggiunta tramite API e quella tramite barcode (se decidiamo di lasciarla)

import 'package:flutter/material.dart';
import '../../models/genere_libro.dart';
import '../../models/stato_libro.dart';
import '../../models/libro.dart';
import '../../models/libreria.dart';

class AggiungiLibroController {
  // Converto le enumerazioni in liste di stringhe per il DropdownButton
  final List<String> generi =
      GenereLibro.values.map((stato) => stato.name).toList();
  final List<String> stati =
      StatoLibro.values
          .map((stato) => stato.name.replaceAll('_', ' '))
          .toList(); // sostituisco gli underscore con spazi

  // Inizializzo i controller per i campi di input
  final TextEditingController titoloController = TextEditingController();
  final TextEditingController autoriController = TextEditingController();
  final TextEditingController numeroPagineController = TextEditingController();
  final TextEditingController linguaController = TextEditingController();
  final TextEditingController tramaController = TextEditingController();
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController dataPubblicazioneController =
      TextEditingController();
  final TextEditingController votoController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String? genereSelezionato; // valore selezionato dal DropdownButton
  String? statoSelezionato; // valore selezionato dal DropdownButton

  final Libreria libreria = Libreria();

  String? titolo;
  List<String>? autori;
  int? numeroPagine;
  String? lingua;
  String? trama;
  String? isbn;
  DateTime? dataPubblicazione;
  double? voto;
  String? copertina; // Placeholder per la copertina, da implementare in futuro
  String? note;
  StatoLibro? stato;
  GenereLibro? genere;

  // Metodo che gestisce il click del pulsante "Aggiungi" nella schermata di aggiunta manuale dei libri
  void handleAggiungi() {
    // Quando l'utente preme il pulsante "Aggiungi", vengono recuperati i valori dai controller

    titolo = titoloController.text.trim();
    autori = autoriController.text.split(',').map((e) => e.trim()).toList();
    numeroPagine = int.tryParse(numeroPagineController.text);
    lingua = linguaController.text.trim();
    trama = tramaController.text.trim();
    isbn = isbnController.text.toUpperCase().trim();
    dataPubblicazione = DateTime.tryParse(dataPubblicazioneController.text);
    voto = double.tryParse(votoController.text);
    note = noteController.text;

    try {
      genere = GenereLibro.values.firstWhere(
        (genere) => genere.name == genereSelezionato,
      );
    } catch (e) {
      genere = null; //se non viene selezionato un genere, lo setto a null
    }
    try {
      stato = StatoLibro.values.firstWhere(
        (stato) => stato.name == statoSelezionato,
      );
    } catch (e) {
      stato = null; //se non viene selezionato uno stato, lo setto a null
    }

    if (controllaCampi()) {
      // Se i campi sono stati compilati correttamente, viene creato un nuovo libro
      Libro nuovoLibro = Libro(
        titolo: titolo!,
        autori: autori,
        numeroPagine: numeroPagine,
        genere: genere,
        lingua: lingua,
        trama: trama,
        isbn: isbn!,
        dataPubblicazione: dataPubblicazione,
        voto: voto,
        copertina: copertina,
        note: note,
        stato: stato,
      );

      // A questo punto, il libro può essere aggiunto alla libreria
      libreria.aggiungiLibro(nuovoLibro);
    } 
  }

  bool controllaCampi() {
    // Controlla se i campi sono stati compilati correttamente\
    // Le eccezioni vengono catturate all'interno della vista... e mostrato un alert 
    bool status = true;

    if (titolo?.isEmpty == true) {
      status = false;
      throw Exception("Il titolo non può essere vuoto");
    }

    if (isbn?.isEmpty == true) {
      status = false;
      throw Exception("L'ISBN non può essere vuoto");
    }

    return status;
  }
}
