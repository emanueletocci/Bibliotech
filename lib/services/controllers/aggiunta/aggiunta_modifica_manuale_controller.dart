import 'package:bibliotech/services/controllers/aggiunta/aggiunta_base_controller.dart';
import 'package:flutter/material.dart';
import '../../../models/genere_libro_model.dart';
import '../../../models/stato_libro_model.dart';
import '../../../models/libro_model.dart';
import '../../../models/libreria_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../utilities/file_utility.dart';
import 'package:path/path.dart' as p;

/// Controller per la gestione dell'aggiunta e modifica manuale dei libri.
/// Gestisce la logica per aggiungere un nuovo libro o modificare un libro esistente nella libreria.
/// Fornisce metodi per la selezione della copertina, il recupero dei dati dai campi e la validazione.
class AggiuntaModificaManualeController extends GenericController {
  /// Lista dei generi disponibili.
  final List<GenereLibro> generi = GenereLibro.values.toList();

  /// Lista degli stati disponibili.
  final List<StatoLibro> stati = StatoLibro.values.toList();

  /// Flag booleano per distinguere tra aggiunta e modifica.
  bool _isEditable = false;

  /// Riferimento al libro da modificare, se presente.
  Libro? _libroDaModificare;

  /// Riferimento alla libreria gestita dal controller.
  final Libreria _libreria;

  /// Controller per il campo titolo.
  final TextEditingController titoloController = TextEditingController();

  /// Controller per il campo autori.
  final TextEditingController autoriController = TextEditingController();

  /// Controller per il campo numero pagine.
  final TextEditingController numeroPagineController = TextEditingController();

  /// Controller per il campo lingua.
  final TextEditingController linguaController = TextEditingController();

  /// Controller per il campo trama.
  final TextEditingController tramaController = TextEditingController();

  /// Controller per il campo ISBN.
  final TextEditingController isbnController = TextEditingController();

  /// Controller per il campo data pubblicazione.
  final TextEditingController dataPubblicazioneController =
      TextEditingController();

  /// Controller per il campo voto.
  final TextEditingController votoController = TextEditingController();

  /// Controller per il campo note.
  final TextEditingController noteController = TextEditingController();

  /// Costruttore con parametro opzionale per modificare un libro esistente.
  /// Se il parametro è presente, inizializza i campi con i valori del libro da modificare.
  /// Il controller gestisce quindi la modifica del libro.
  AggiuntaModificaManualeController(this._libreria, [Libro? libroDaModificare])
    : super() {
    if (libroDaModificare != null) {
      _libroDaModificare = libroDaModificare;
      _initFields(libroDaModificare);
      copertina = libroDaModificare.copertina!;
      _isEditable =
          true; // Imposto il flag per indicare che si sta modificando un libro
    } else {
      copertina =
          'assets/images/book_placeholder.jpg'; // Imposto un placeholder di default
      isbn = '';
      _isEditable =
          false; // Imposto il flag per indicare che si sta aggiungendo un  nuovo libro
    }
  }

  /// Inizializza i campi del controller con i valori del libro da modificare.
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

  /// Metodo per la selezione e salvataggio della copertina dalla galleria.
  /// Assegna il percorso locale del file salvato all'attributo 'copertina'.
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

  /// Recupera i valori formattati dai textfields e li assegna alle proprietà del controller.
  void _getFromFields() {
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

    // Effettuo parsing e conversione degli isbn
    String? rawIsbn = isbnController.text.toUpperCase().trim();
    isbn = isbnValidator.toCanonical(rawIsbn);

    dataPubblicazione = DateTime.tryParse(dataPubblicazioneController.text);
    voto = double.tryParse(votoController.text);
    note = noteController.text;
    genere = genereSelezionato;
    stato = statoSelezionato;
  }

  /// Gestisce il click del pulsante "Aggiungi" nella schermata di aggiunta manuale dei libri.
  /// Consente l'aggiunta di nuovi libri o la modifica di libri esistenti.
  @override
  void handleAggiungiLibro() {
    _getFromFields();

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

  /// Controlla la validità dei campi del libro prima di aggiungerlo o modificarlo.
  /// Verifica che non esista già un libro con lo stesso ISBN in libreria.
  /// Restituisce true se i campi sono validi, altrimenti lancia un'eccezione.
  @override
  bool controllaCampi() {
    bool status = super.controllaCampi();

    if (_isEditable) {
      // Modalitá modifica
      if (isbn != _libroDaModificare!.isbn) {
        // Se il nuovo ISBN è diverso, verifico che non esista già un libro con quel ISBN
        if (_libreria.cercaLibroPerIsbn(isbn) != null) {
          status = false;
          throw Exception(
            "Il libro con questo ISBN è già presente in libreria",
          );
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
