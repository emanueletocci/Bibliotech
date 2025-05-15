import 'categoria.dart';

class Libro {
  String titolo;
  List<String>? autori;
  int? numeroPagine;
  List<Categoria>? categorie;  // usiamo direttamente la classe Categoria
  String? lingua;
  String? trama;
  String isbn;
  DateTime? dataPubblicazione;
  List<String> recensioni; 
  double? voto;
  String? copertina;  // qui ci va il link alla copertina
  bool preferito;
  bool letto;

  Libro({
    required this.titolo,
    this.autori,
    this.numeroPagine,
    this.categorie,
    this.lingua,
    this.trama,
    required this.isbn,
    this.dataPubblicazione,
    this.recensioni = const [],
    this.copertina,
    this.preferito = false,
    this.letto = false,
  });

  void aggiungiRecensione(String recensione) {
    recensioni.add(recensione);
  }

  void segnaComePreferito() {
    preferito = true;
  }

  void togliDaiPreferiti() {
    preferito = false;
  }

  void segnaComeLetto() {
    letto = true;
  }
}
