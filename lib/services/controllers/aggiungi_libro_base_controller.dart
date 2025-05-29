

import '../../models/genere_libro.dart';
import '../../models/stato_libro.dart';

abstract class BaseLibroController {
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
  BaseLibroController();

  bool controllaCampi(){
    bool status = true;

    if (titolo.isEmpty == true) {
      status = false;
      throw Exception("Il titolo non può essere vuoto");
    }

    if (isbn.isEmpty == true) {
      status = false;
      throw Exception("L'ISBN non può essere vuoto");
    }

    // Validazione ISBN mediante regex
    // https://www.geeksforgeeks.org/regular-expressions-to-validate-isbn-code/
    // https://www.oreilly.com/library/view/regular-expressions-cookbook/9781449327453/ch04s13.html
    /*
    final isbnRegex = RegExp(r"^(?=(?:[^0-9]*[0-9]){10}(?:(?:[^0-9]*[0-9]){3})?$)[\\d-]+$");
    if(isbnRegex.matchAsPrefix(isbn) == null) {
      status = false;
      throw Exception("L'ISBN non è valido");
    }
    */
    return status;
  
  }

}