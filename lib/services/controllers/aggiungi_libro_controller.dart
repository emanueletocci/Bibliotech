import 'package:bibliotech/services/controllers/aggiungi_libro_base_controller.dart';
import 'package:flutter/material.dart';
import '../../models/genere_libro.dart';
import '../../models/stato_libro.dart';
import '../../models/libro.dart';
import '../../models/libreria.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../utilities/file_utility.dart';
import 'package:path/path.dart' as p;

class AggiungiLibroController extends BaseLibroController{
  final List<GenereLibro> generi = GenereLibro.values.toList();
  final List<StatoLibro> stati = StatoLibro.values.toList();

  // Flag booleano per distinguere tra aggiunta e modifica
  bool _isEditable = false;
  Libro? _libroDaModificare;

  // La libreria é ottenuta dalla view tramite il provider
  final Libreria _libreria;

  // Text Fields
  final TextEditingController titoloController = TextEditingController();
  final TextEditingController autoriController = TextEditingController();
  final TextEditingController numeroPagineController = TextEditingController();
  final TextEditingController linguaController = TextEditingController();
  final TextEditingController tramaController = TextEditingController();
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController dataPubblicazioneController = TextEditingController();
  final TextEditingController votoController = TextEditingController();
  final TextEditingController noteController = TextEditingController();


  // Costruttore con parametro opzionale per modificare un libro esistente
  // Se il parametro é presente, inizializza i campi con i valori del libro da modificare
  // Il controller gestisce quindi la modifica del libro
  AggiungiLibroController(this._libreria, [Libro? libroDaModificare]): 
    super() {
    if (libroDaModificare != null) {
      _libroDaModificare = libroDaModificare;
      _initFields(libroDaModificare);
      copertina = libroDaModificare.copertina!;
      _isEditable = true; // Imposto il flag per indicare che si sta modificando un libro
    } else {
      copertina =
          'assets/images/book_placeholder.jpg'; // Imposto un placeholder di default
      isbn = '';
      _isEditable =
          false; // Imposto il flag per indicare che si sta aggiungendo un  nuovo libro
    }
  }

  // Se il libro é presente, inizializza i campi con i valori del libro da modificare
  void _initFields(Libro libro) {
    titoloController.text = libro.titolo;
    autoriController.text = libro.autori?.join(', ') ?? '';
    numeroPagineController.text = libro.numeroPagine?.toString() ?? '';
    linguaController.text = libro.lingua ?? '';
    tramaController.text = libro.trama ?? '';
    isbnController.text = libro.isbn;
    dataPubblicazioneController.text =
        libro.dataPubblicazione?.toString() ?? '';
    votoController.text = libro.voto?.toString() ?? '';
    noteController.text = libro.note ?? '';
    genereSelezionato = libro.genere;
    statoSelezionato = libro.stato;
    isPreferito = libro.preferito;
  }

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
      final File savedImage = await FileUtility.saveFile(imageFile, fileName);
      copertina =
          savedImage.path; // Memorizza il percorso locale dell'immagine salvata
    } else {
      return; // Se non viene selezionata nessuna immagine, lascio il placeholder di default
    }
  }

  // Metodo che gestisce il click del pulsante "Aggiungi" nella schermata di aggiunta manuale dei libri
  void handleAggiungi() {
    // Recupero i valori dai controller e li pulisco
    titolo = titoloController.text.trim();
    autori =
        autoriController.text
            .split(',')
            .map((e) => e.trim())
            .where(
              (e) => e.isNotEmpty,
            ) // Filtro le liste per rimuovere eventuali stringhe vuote
            .toList();

    numeroPagine = int.tryParse(numeroPagineController.text);
    lingua = linguaController.text.trim();
    trama = tramaController.text.trim();
    isbn = isbnController.text.toUpperCase().trim();
    dataPubblicazione = DateTime.tryParse(dataPubblicazioneController.text);
    voto = double.tryParse(votoController.text);
    note = noteController.text;
    genere = genereSelezionato;
    stato = statoSelezionato;

    if (!controllaCampi()) {
      return; // Se i campi non sono validi, esco direttamente
    }

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

    if (_libroDaModificare != null) {
      // Se il libro da modificare é presente, lo aggiorno
      _libreria.modificaLibro(_libroDaModificare!, nuovoLibro);
    } else {
      // Altrimenti lo aggiungo come nuovo libro
      _libreria.aggiungiLibro(nuovoLibro);
    }
  }

  @override
  bool controllaCampi() {
    bool status = super.controllaCampi();

    if (_isEditable) {
      // Modalitá modifica
      if(isbn != _libroDaModificare!.isbn){
        // Se il nuovo ISBN è diverso, verifico che non esista già un libro con quel ISBN
        if(_libreria.cercaLibroPerIsbn(isbn) != null) {
          status = false;
          throw Exception("Il libro con questo ISBN è già presente in libreria");
        }
      }
    } else {
      // Modalitá aggiunta
      if (_libreria.cercaLibroPerIsbn(isbn) != null) {  
        status = false;
        throw Exception("Il libro con questo ISBN è già presente in libreria");
      }
    }

    return status;
  }
}
