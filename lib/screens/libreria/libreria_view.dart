import 'package:bibliotech/models/libro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/libreria.dart';
import '../../components/libro_cover_widget.dart';

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

    // Ho rimosso lo scaffold dato che é giá presente nel widget principale
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
                                  child: LibroCoverWidget(libro: libro),
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
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(8.0)),
              Image(
                image: AssetImage('assets/images/cover1.jpg'),
                width: 60,
                height: 90,
                fit: BoxFit.cover,
              ),
              Text('Fantasy', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(8.0)),
              Image(
                image: AssetImage('assets/images/cover2.jpg'),
                width: 60,
                height: 90,
                fit: BoxFit.cover,
              ),
              Text('Thriller', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(8.0)),
              Image(
                image: AssetImage('assets/images/cover3.jpg'),
                width: 60,
                height: 90,
                fit: BoxFit.cover,
              ),
              Text('Leteraly', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(8.0)),
              // caricaLibri is now inside _LibreriaState
              Text('Science', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
