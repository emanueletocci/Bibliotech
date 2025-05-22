import 'package:bibliotech/models/db.dart';
import 'package:bibliotech/models/genere_libro.dart';
import 'package:bibliotech/models/libro.dart' as models;
import 'package:bibliotech/models/stato_libro.dart';
import 'package:bibliotech/screens/main_view.dart';
import 'package:flutter/material.dart';
import 'themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await libri; // Inizializza il database
  prova(); // Inserisci i libri di esempio (se vuoi)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bibliotech',
      theme: appTheme,
      home: const MainScreen(),
    );
  }
}

void prova() {
  final l1 = models.Libro(
    id: 1,
    titolo: 'Il Signore degli Anelli',
    autori: 'J.R.R. Tolkien',
    numeroPagine: 1200,
    genere: GenereLibro.fantasy,
    lingua: 'Italiano',
    trama: 'Un epico viaggio nella Terra di Mezzo.',
    isbn: '978-1234567890',
    dataPubblicazione: DateTime(1954, 7, 29),
    voto: 5,
    copertina: 'copertina.jpg',
    note: 'Edizione illustrata',
    stato: StatoLibro.letto,
    urlimg: 'assets/images/book2.jpg',
  );

  final l2 = models.Libro(
    id: 2,
    titolo: '1984',
    autori: 'George Orwell',
    numeroPagine: 328,
    genere: GenereLibro.fantascienza,
    lingua: 'Italiano',
    trama: 'Un futuro distopico sotto un regime totalitario.',
    isbn: '978-0451524935',
    dataPubblicazione: DateTime(1949, 6, 8),
    voto: 4,
    copertina: 'copertina2.jpg',
    note: 'Classico della letteratura',
    stato: StatoLibro.letto,
    urlimg: 'assets/images/book1.jpg',
  );

  final l3 = models.Libro(
    id: 3,
    titolo: 'Il Piccolo Principe',
    autori: 'Antoine de Saint-Exupéry',
    numeroPagine: 96,
    genere: GenereLibro.fantasy,
    lingua: 'Italiano',
    trama: 'Un viaggio poetico tra pianeti e amicizia.',
    isbn: '978-0156012195',
    dataPubblicazione: DateTime(1943, 4, 6),
    voto: 5,
    copertina: 'copertina3.jpg',
    note: 'Adatto a tutte le età',
    stato: StatoLibro.daLeggere,
    urlimg: 'assets/images/book3.jpg',
  );

  final l4 = models.Libro(
    id: 4,
    titolo: 'Orgoglio e Pregiudizio',
    autori: 'Jane Austen',
    numeroPagine: 432,
    genere: GenereLibro.romanzo,
    lingua: 'Italiano',
    trama: 'Una storia d\'amore nell\'Inghilterra del XIX secolo.',
    isbn: '978-0141439518',
    dataPubblicazione: DateTime(1813, 1, 28),
    voto: 4,
    copertina: 'copertina4.jpg',
    note: 'Romanzo classico',
    stato: StatoLibro.inLettura,
    urlimg: 'assets/images/book4.jpg',
  );

  final l5 = models.Libro(
    id: 5,
    titolo: 'Il Codice Da Vinci',
    autori: 'Dan Brown',
    numeroPagine: 454,
    genere: GenereLibro.thriller,
    lingua: 'Italiano',
    trama: 'Un mistero tra arte, religione e storia.',
    isbn: '978-0307474278',
    dataPubblicazione: DateTime(2003, 3, 18),
    voto: 3,
    copertina: 'copertina5.jpg',
    note: 'Thriller avvincente',
    stato: StatoLibro.daLeggere,
    urlimg: 'assets/images/book5.jpg',
  );

  final l6 = models.Libro(
    id: 6,
    titolo: 'Harry Potter e la Pietra Filosofale',
    autori: 'J.K. Rowling',
    numeroPagine: 223,
    genere: GenereLibro.fantasy,
    lingua: 'Italiano',
    trama: 'L\'inizio della saga del maghetto più famoso.',
    isbn: '978-0747532699',
    dataPubblicazione: DateTime(1997, 6, 26),
    voto: 5,
    copertina: 'copertina6.jpg',
    note: 'Primo libro della saga',
    stato: StatoLibro.letto,
    urlimg: 'assets/images/book6.jpg',
  );

  insertLibro(l1);
  insertLibro(l2);
  insertLibro(l3);
  insertLibro(l4);
  insertLibro(l5);
  insertLibro(l6);
}
