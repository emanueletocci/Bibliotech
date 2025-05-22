import 'genere_libro.dart';
import 'stato_libro.dart';

class Libro {
  int id;
  String titolo;
  String? autori;
  int? numeroPagine;
  GenereLibro? genere;
  String? lingua;
  String? trama;
  String isbn;
  DateTime? dataPubblicazione;
  double? voto;
  String? copertina;
  String? note;
  String? urlimg;
  StatoLibro? stato;

  /// Costruisce un'istanza della classe [Libro] pronto da copiare.
  /// final libro = Libro(
  ///   id: '1',
  ///   titolo: 'Il Signore degli Anelli',
  ///   autori: ['J.R.R. Tolkien'],
  ///   numeroPagine: 1200,
  ///   genere: 'Fantasy',
  ///   lingua: 'Italiano',
  ///   trama: 'Un epico viaggio nella Terra di Mezzo.',
  ///   isbn: '978-1234567890',
  ///   dataPubblicazione: DateTime(1954, 7, 29),
  ///   voto: 5,
  ///   copertina: 'copertina.jpg',
  ///   note: 'Edizione illustrata',
  ///   stato: 'Letto',
  ///   urlimg: 'https://esempio.com/copertina.jpg',
  /// );
  /// ```
  Libro({
    required this.id,
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
    this.urlimg,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'titolo': titolo,
      'autori': autori,
      'numeroPagine': numeroPagine,
      'genere': genere?.toString(),
      'lingua': lingua,
      'trama': trama,
      'isbn': isbn,
      'dataPubblicazione': dataPubblicazione?.toIso8601String(),
      'voto': voto,
      'copertina': copertina,
      'note': note,
      'urlimg': urlimg,
      'stato': stato?.toString(),
    };
  }

  @override
  String toString() {
    return 'Libro{id: $id, titolo: $titolo, autori: $autori, numeroPagine: $numeroPagine, genere: $genere, lingua: $lingua, trama: $trama, isbn: $isbn, dataPubblicazione: $dataPubblicazione, voto: $voto, copertina: $copertina, note: $note, urlimg: $urlimg, stato: $stato}';
  }
}
