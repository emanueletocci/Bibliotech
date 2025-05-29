

import '../../../models/genere_libro_model.dart';
import '../../../models/stato_libro_model.dart';
import 'package:isbn/isbn.dart';

abstract class GenericController {
  final Isbn isbnValidator = Isbn();

  GenereLibro? genereSelezionato;
  StatoLibro? statoSelezionato;
  String titolo = '';
  List<String>? autori;
  int? numeroPagine;
  String? lingua;
  String? trama;
  String isbn = '';
  DateTime? dataPubblicazione;
  double? voto;
  String copertina = 'assets/images/book_placeholder.jpg';
  String? note;
  StatoLibro? stato;
  GenereLibro? genere;

  // Imposto preferito a false di default
  bool isPreferito = false;

  bool controllaCampi(){
    bool status = true;

    if (titolo.isEmpty) {
      status = false;
      throw Exception("Il titolo non può essere vuoto");
    }
    // Controllo se l'isbn inserito é valido
    if(isbnValidator.notIsbn(isbn, strict: false)) {
      status = false;
      throw Exception("L'ISBN inserito non è valido");
    }
    
    return status;
  }

  // Definizione di metodi astratti che devono essere implementati dalle classi figlie
  void handleAggiungiLibro();
}