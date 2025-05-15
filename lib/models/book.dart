import 'categoria.dart';

class Libro {
  String titolo;
  List<String>? autori;
  int? numeroPagine;
  List<Categoria>? categorie;
  String? lingua;
  String? trama;
  String isbn;
  DateTime? dataPubblicazione;
  double? voto;
  String? copertina;
  bool? preferito;
  bool? letto;
  bool? wishlist;

  Libro({
    required this.titolo,
    this.autori,
    this.numeroPagine,
    this.categorie,
    this.lingua,
    this.trama,
    required this.isbn,
    this.dataPubblicazione,
    this.voto,
    this.copertina,
    this.preferito,
    this.letto,
    this.wishlist,
  });


}
