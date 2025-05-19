import 'genere-libro.dart';
import 'stato-libro.dart';
class Libro {
  String titolo;  
  List<String>? autori; 
  int? numeroPagine;
  List<GenereLibro>? generi;
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
    this.generi,
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
