class Libro {
  // aggiungere foto e voto

  String titolo;
  List<String> autori;
  int numeroPagine;
  List<String> categorie;
  String? lingua;
  String trama;
  String? isbn;
  DateTime? dataPubblicazione;
  List<String> recensioni; 
  double? voto;
  String? copertina;  // qui ci va il link alla copertina
  bool preferito;
  bool letto;

  Libro({
    required this.titolo,
    required this.autori,
    required this.numeroPagine,
    required this.categorie,
    this.lingua,
    required this.trama,
    this.isbn,
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
