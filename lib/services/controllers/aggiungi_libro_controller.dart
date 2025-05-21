import 'package:flutter/material.dart';
import '../../models/genere_libro.dart';
import '../../models/stato_libro.dart';
import '../../models/libro.dart';
import '../../models/libreria.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../utilities/file_utility.dart';
import 'package:path/path.dart' as p;

class AggiungiLibroController {
  final List<String> generi =
  GenereLibro.values.map((stato) => stato.name).toList();
  final List<String> stati =
  StatoLibro.values.map((stato) => stato.name.replaceAll('_', ' ')).toList();

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

  String? genereSelezionato;
  String? statoSelezionato;

  final Libreria libreria = Libreria();

  String? titolo;
  List<String>? autori;
  int? numeroPagine;
  String? lingua;
  String? trama;
  String isbn;
  DateTime? dataPubblicazione;
  double? voto;
  String copertina;
  String? note;
  StatoLibro? stato;
  GenereLibro? genere;

  AggiungiLibroController() :
    copertina = 'assets/images/book_placeholder.jpg',
    isbn= '';
  

  // Metodo per la selezione e salvataggio della copertina dalla galleria
  // Questa funzione assegna il percorso locale del file salvato all'attributo 'copertina'.
  Future<void> selezionaCopertina() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final String fileName = p.basename(pickedFile.path);
      final File savedImage = await FileUtility.saveFile(
        imageFile,
        fileName,
      );
      copertina = savedImage.path; // Memorizza il percorso locale dell'immagine salvata
    } else {
      return; // Se non viene selezionata nessuna immagine, lascio il placeholder di default
    }
  }

  // Metodo che gestisce il click del pulsante "Aggiungi" nella schermata di aggiunta manuale dei libri
  void handleAggiungi() {
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
      genere = null;
    }
    try {
      stato = StatoLibro.values.firstWhere(
            (stato) => stato.name == statoSelezionato,
      );
    } catch (e) {
      stato = null;
    }

    if (controllaCampi()) {
      Libro nuovoLibro = Libro(
        titolo: titolo!,
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
      );

      libreria.aggiungiLibro(nuovoLibro);
    }
  }

  bool controllaCampi() {
    bool status = true;

    if (titolo?.isEmpty == true) {
      status = false;
      throw Exception("Il titolo non può essere vuoto");
    }

    if (isbn.isEmpty == true) {
      status = false;
      throw Exception("L'ISBN non può essere vuoto");
    }

    // Inserire validazione ISBN

    // Se il libro é giá presente, non lo aggiungo e lancio eccezione
    if(libreria.cercaLibroPerIsbn(isbn) != null){
      status = false;
      throw Exception("Il libro con questo ISBN è già presente in libreria");
    }

    return status;
  }
}