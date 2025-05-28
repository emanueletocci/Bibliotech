enum GenereLibro {
  poesia('Poesia', 'assets/images/generi/poesia.jpg'),
  biografia('Biografia', 'assets/images/generi/biografia.jpg'),
  fantasy('Fantasy', 'assets/images/generi/fantasy.jpg'),
  fantascienza('Fantascienza', 'assets/images/generi/fantascienza.jpg'),
  horror('Horror', 'assets/images/generi/horror.jpg'),
  giallo('Giallo', 'assets/images/generi/giallo.jpg'),
  thriller('Thriller', 'assets/images/generi/thriller.jpg'),
  storico('Storico', 'assets/images/generi/storico.jpg'),
  classico('Classico', 'assets/images/generi/classico.jpg'),
  graphicNovel('Graphic Novel', 'assets/images/generi/graphic_novel.jpg'),
  istruzione('Istruzione', 'assets/images/generi/istruzione.jpg'),
  bambini('Bambini', 'assets/images/generi/bambini.jpg'),
  cucina('Cucina', 'assets/images/generi/cucina.jpg'),
  viaggi('Viaggi', 'assets/images/generi/viaggi.jpg'),
  arte('Arte', 'assets/images/generi/arte.jpg'),
  salute('Salute', 'assets/images/generi/salute.jpg'),
  economia('Economia', 'assets/images/generi/economia.jpg'),

  // Le macro-categorie sono state posizionate alla fine per dare priorità ai generi specifici
  // La mappa infatti viene letta in ordine per cui si da prioritá alle prime entry
  romanzo('Romanzo', 'assets/images/generi/romanzo.jpg'),
  saggio('Saggio', 'assets/images/generi/saggio.jpg'),
  noCategoria('Nessuna Categoria', 'assets/images/generi/nessuna_categoria.jpg');

  final String titolo;
  final String percorsoImmagine;

  const GenereLibro(this.titolo, this.percorsoImmagine);

  @override
  String toString() {
    return titolo;
  }
}
