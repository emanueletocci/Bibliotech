import 'package:flutter/material.dart';
import '../../components/popup_aggiunta.dart';
import '../../models/libreria.dart';
import '../../models/libro.dart';
import '../../components/libro_cover_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Libreria _libreria;

  // Inizializzo manualmente le variabili di stato. Viene eseguito prima del build
  // initState si usa per inizializzare variabili di stato che richiedono un'inizializzazione
  // complessa, dipendente da altre variabili o oggetti (come la libreria)
  @override
  void initState() {
    super.initState();
    _libreria = Libreria();
  }

  // callaback per la gestione dello stato nei widget figli
  // Per semplicitá il metodo viene chiamato alla chiusura del popup di aggiunta, sia nel caso in cui
  // é stato effettivamente inserito un libro, sia nel caso in cui l'utente ha chiuso semplicemente il popup
  void _onLibreriaChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 15,
        children: <Widget>[
          Header(
            libreria: _libreria,
            onLibreriaChanged: _onLibreriaChanged,
          ), // passo la libreria al widget Header
          Body(libreria: _libreria), // passo la libreria al widget Body
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  final Libreria? libreria;
  final VoidCallback onLibreriaChanged;
  const Header({super.key, this.libreria, required this.onLibreriaChanged});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 250,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF8F5CFF),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(70),
              bottomLeft: Radius.circular(150),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey,
                spreadRadius: 1,
                blurRadius: 15,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                child: Text(
                  "Welcome!",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled:
                          true, // consente al popup di occupare tutto lo schermo
                      builder: (context) {
                        return const PopupAggiunta();
                      },
                    );
                    onLibreriaChanged(); // forzo l'aggiornamento della UI tramite callback
                  },
                  icon: const Icon(Icons.add, size: 25),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(280, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        "Aggiungi un libro!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Stai leggendo qualcosa?",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Body extends StatelessWidget {
  final Libreria libreria;
  const Body({super.key, required this.libreria});

  @override
  Widget build(BuildContext context) {
    final List<Libro> libri = libreria.getLibri();
    final List<Libro> libriConsigliati = libri.take(3).toList();
    final List<Libro> ultimeAggiunte = libri.reversed.take(3).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        spacing: 20,
        children: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // spacing: 10, // Rimosso: Row non ha 'spacing'
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.blind, size: 25),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 3,
                  ),
                  label: const Text("Wishlist", style: TextStyle(fontSize: 18)),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite, size: 25),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  label: const Text(
                    "Preferiti",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Libri consigliati",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 150,
                child: Builder(
                  builder: (BuildContext context) { // 'builder' deve essere il nome del parametro
                    if (libriConsigliati.isEmpty) {
                      return const Center(
                        child: Text("Nessun libro consigliato al momento."),
                      );
                    } else {
                      return CarouselView(
                        itemExtent: 166,
                        children: libriConsigliati.map((libro) {
                          return Container(
                            width: 150, // Larghezza desiderata della copertina
                            height: 150, // Altezza desiderata della copertina
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ), // Spazio tra le copertine
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: LibroCoverWidget(libro: libro),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  }, // Chiusura corretta del Builder
                ),
              ),
              const Text(
                "Ultime aggiunte",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 150,
                child: Builder( // Usiamo Builder per poter usare if/else direttamente qui
                  builder: (BuildContext context) {
                    if (ultimeAggiunte.isEmpty) {
                      return const Center(child: Text("Nessuna aggiunta recente."));
                    } else {
                      return CarouselView(
                        itemExtent: 166,
                        children: ultimeAggiunte.map((libro) {
                          return Container(
                            width: 150,
                            height: 150,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: LibroCoverWidget(libro: libro),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}