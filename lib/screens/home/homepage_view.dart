import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/popup_aggiunta.dart';
import '../../components/libro_cover_widget.dart';
import '../../services/controllers/homepage_controller.dart';
// Rimosso import '../../models/libreria.dart';
// Rimosso import '../../models/libro.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 15,
        children: <Widget>[
          const Header(),
          const Body(),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

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
                  onPressed: () async{
                    final bool? shouldRefresh = await showModalBottomSheet( // Modificato da dynamic a bool?
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return const PopupAggiunta();
                      },
                    );
                    // Ripristinato il controllo originale con shouldRefresh
                    if (shouldRefresh == true) {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(const SnackBar(content: Text('Operazione libro completata.')));
                    }
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
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Row(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
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
              const Text(
                "Libri consigliati",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 200,
                child: Consumer<HomepageController>(
                  builder: (BuildContext context, HomepageController homepageController, Widget? child) {
                    if (homepageController.libriConsigliati.isEmpty) {
                      return const Center(
                        child: Text("Nessun libro consigliato al momento."),
                      );
                    } else {
                      return CarouselView(
                        itemExtent: 166,
                        children:
                            homepageController.libriConsigliati.map((libro) {
                              return Container(
                                width:
                                    150,
                                height:
                                    150,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
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
              const Text(
                "Ultime aggiunte",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 200,
                child: Consumer<HomepageController>(
                  builder: (BuildContext context, HomepageController homepageController, Widget? child) {
                    if (homepageController.ultimeAggiunte.isEmpty) {
                      return const Center(
                        child: Text("Nessuna aggiunta recente."),
                      );
                    } else {
                      return CarouselView(
                        itemExtent: 166,
                        children:
                            homepageController.ultimeAggiunte.map((libro) {
                              return Container(
                                width: 150,
                                height: 150,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
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
    );
  }
}