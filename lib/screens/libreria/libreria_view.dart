import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/libreria.dart';
import '../../components/libro_cover_widget.dart';
import '../../models/genere_libro.dart';
import '../dettagli_libro/dettagli_libro_view.dart';

class LibreriaPage extends StatefulWidget {
  const LibreriaPage({super.key});

  @override
  State<LibreriaPage> createState() => _LibreriaPageState();
}

class _LibreriaPageState extends State<LibreriaPage> {
  @override
  void initState() {
    super.initState();
    // caricaLibri();
  }
  /*
  Future<void> caricaLibri() async {
    final lista = await getLibri();
    setState(() {
      libri = lista;
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    final libreria = context.watch<Libreria>();
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBarCustom(),
            Generi(),
            Expanded(
              child: SizedBox(
                height: 200,
                child:
                    libreria.getLibri().isEmpty
                        ? const Center(
                          child: Text("Nessun libro presente nella libreria"),
                        )
                        : GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                          children:
                              libreria.getLibri().map((libro) {
                                return Container(
                                  width: 150,
                                  height: 150,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  DettagliLibro(libro: libro),
                                        ),
                                      );
                                      debugPrint(
                                        'Hai premuto il libro: ${libro.titolo}',
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: LibroCoverWidget(libro: libro),
                                  ),
                                );
                              }).toList(),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBarCustom extends StatelessWidget {
  const SearchBarCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(21)),
        hintText: 'Search Book',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}

class Generi extends StatelessWidget {
  const Generi({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children:
            GenereLibro.values.map((genere) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  spacing: 5,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Container per l'immagine
                    GestureDetector(
                      // Inserire QUI il filtro
                      onTap: () {
                        print("Filtro per genere: ${genere.titolo}");
                      },
                      child: Container(
                        width: 50,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            genere.percorsoImmagine,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Text(genere.titolo, textAlign: TextAlign.center),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}
