import 'genere_libro.dart';
import 'stato_libro.dart';

class Libro {
  String titolo;  
  List<String>? autori; 
  int? numeroPagine;
  GenereLibro? genere;
  String? lingua;   
  String? trama;
  String isbn;
  DateTime? dataPubblicazione;  
  double? voto;
  String? copertina;  
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

}
