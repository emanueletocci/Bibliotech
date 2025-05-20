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
  String? copertinaUrl;         // URL della copertina
  String? copertinaLocalPath;   // Percorso locale della copertina (se presente)
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
    this.copertinaUrl,
    this.copertinaLocalPath, // Aggiungi questo nel costruttore
    this.note,
    this.stato,
  });

  // Metodo per stabilire quale copertina mostrare
  String? get currentCover {
    // se é stata caricata una copertina locale mostra quella,
    if (copertinaLocalPath != null && copertinaLocalPath!.isNotEmpty) {
      return copertinaLocalPath;
    }
    return copertinaUrl;
  }

}
