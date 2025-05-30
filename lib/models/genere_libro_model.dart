/// Enum che rappresenta i generi disponibili per un libro.
/// Ogni genere ha un titolo descrittivo e un percorso immagine associato.
enum GenereLibro {
  /// Genere poesia.
  poesia('Poesia', 'assets/images/generi/poesia.jpg'),

  /// Genere biografia.
  biografia('Biografia', 'assets/images/generi/biografia.jpg'),

  /// Genere fantasy.
  fantasy('Fantasy', 'assets/images/generi/fantasy.jpg'),

  /// Genere fantascienza.
  fantascienza('Fantascienza', 'assets/images/generi/fantascienza.jpg'),

  /// Genere horror.
  horror('Horror', 'assets/images/generi/horror.jpg'),

  /// Genere giallo.
  giallo('Giallo', 'assets/images/generi/giallo.jpg'),

  /// Genere thriller.
  thriller('Thriller', 'assets/images/generi/thriller.jpg'),

  /// Genere storico.
  storico('Storico', 'assets/images/generi/storico.jpg'),

  /// Genere classico.
  classico('Classico', 'assets/images/generi/classico.jpg'),

  /// Genere graphic novel.
  graphicNovel('Graphic Novel', 'assets/images/generi/graphic_novel.jpg'),

  /// Genere istruzione.
  istruzione('Istruzione', 'assets/images/generi/istruzione.jpg'),

  /// Genere bambini.
  bambini('Bambini', 'assets/images/generi/bambini.jpg'),

  /// Genere cucina.
  cucina('Cucina', 'assets/images/generi/cucina.jpg'),

  /// Genere viaggi.
  viaggi('Viaggi', 'assets/images/generi/viaggi.jpg'),

  /// Genere arte.
  arte('Arte', 'assets/images/generi/arte.jpg'),

  /// Genere salute.
  salute('Salute', 'assets/images/generi/salute.jpg'),

  /// Genere economia.
  economia('Economia', 'assets/images/generi/economia.jpg'),

  // Le macro-categorie sono state posizionate alla fine per dare priorità ai generi specifici
  // La mappa infatti viene letta in ordine per cui si da prioritá alle prime entry

  /// Genere romanzo.
  romanzo('Romanzo', 'assets/images/generi/romanzo.jpg'),

  /// Genere saggio.
  saggio('Saggio', 'assets/images/generi/saggio.jpg'),

  /// Nessuna categoria specificata.
  noCategoria(
    'Nessuna Categoria',
    'assets/images/generi/nessuna_categoria.jpg',
  );

  /// Titolo descrittivo del genere.
  final String titolo;

  /// Percorso dell'immagine associata al genere.
  final String percorsoImmagine;

  /// Costruttore dell'enum [GenereLibro] con titolo e percorso immagine.
  const GenereLibro(this.titolo, this.percorsoImmagine);

  /// Restituisce il titolo descrittivo del genere.
  @override
  String toString() {
    return titolo;
  }
}
