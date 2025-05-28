import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/libreria.dart';
import '../../components/libro_cover_widget.dart';
import '../../models/genere_libro.dart';
import '../dettagli_libro/dettagli_libro_view.dart';

class LibreriaPage extends StatefulWidget {
  const LibreriaPage({super.key});

  // Metodo statico per costruire l'AppBar della pagina Libreria
  // Lo uso in mainScreen per inserire l'AppBar corretta all'interno dello scaffold
  // evintando in questo modo di utilizzare scaffold innestati

static AppBar buildAppBar(BuildContext context) {
  return AppBar(
    title: const Text('Libreria'),
    actions: [
      Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ),
    ],
  );
}

static Drawer? buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Text('Filtri', style: TextStyle(color: Colors.white)),
        ),
        ListTile(
          leading: Icon(Icons.bookmark),
          title: Text('Da leggere'),
          onTap: () {
            Navigator.pop(context); // Chiudi il drawer
            // Applica il filtro
          },
        ),
        ListTile(
          leading: Icon(Icons.book),
          title: Text('In lettura'),
          onTap: () {
            Navigator.pop(context);
            // Applica il filtro
          },
        ),
        ListTile(
          leading: Icon(Icons.check),
          title: Text('Letto'),
          onTap: () {
            Navigator.pop(context);
            // Applica il filtro
          },
        ),
        // Aggiungi altri filtri se vuoi
      ],
    ),
  );
}


  @override
  State<LibreriaPage> createState() => _LibreriaPageState();
}

class _LibreriaPageState extends State<LibreriaPage> {
  // Variabile per tenere traccia del genere selezionato
  // Se null, nessun genere è selezionato e si mostrano tutti i libri
  GenereLibro? genereSelezionato;

  @override
  void initState() {
    super.initState();
  }

  // Callback per l'aggiornamento dello stato in base al genere selezionato
  void filtraPerGenere(GenereLibro? genere) {
    setState(() {
      genereSelezionato = genere;
    });
  }

  @override
  Widget build(BuildContext context) {
    final libreria = context.watch<Libreria>();

    // Ottengo la lista di libri filtrati. 
    // Se il genere non è selezionato, prendo automaticamente tutti i libri
    final libriFiltrati = libreria.getLibriPerGenere(genereSelezionato);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBarCustom(),
            Generi(
              genereSelezionato: genereSelezionato,
              onGenereSelezionato: filtraPerGenere,
              ),
            Expanded(
              child: SizedBox(
                height: 200,
                child:
                    libriFiltrati.isEmpty
                        ? const Center(
                          child: Text("Nessun libro presente nella libreria"),
                        )
                        : GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                          children:
                              libriFiltrati.map((libro) {
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
  final GenereLibro? genereSelezionato;
  final Function(GenereLibro?) onGenereSelezionato;

  const Generi({
    super.key,
    required this.genereSelezionato,
    required this.onGenereSelezionato,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: GenereLibro.values.map((genere) {
          final isSelected = genereSelezionato == genere;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => onGenereSelezionato(genere),
                  child: Container(
                    width: 50,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            )
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        genere.percorsoImmagine,
                        fit: BoxFit.cover,
                        color: isSelected ? null : Colors.black.withAlpha(50),
                        colorBlendMode: isSelected ? null : BlendMode.darken,
                      ),
                    ),
                  ),
                ),
                Text(
                  genere.titolo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

