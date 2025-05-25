enum GenereLibro {
  romanzo('Romanzo', 'assets/images/generi/romanzo.jpg'),
  saggio('Saggio', 'assets/images/generi/saggio.jpg'),
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
  istruzione('Istruzione', 'assets/images/generi/istruzione.jpg');

  final String titolo;
  final String percorsoImmagine;

  const GenereLibro(this.titolo, this.percorsoImmagine);
}
