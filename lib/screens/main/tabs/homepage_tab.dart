import 'package:flutter/material.dart';
import '../../../components/popup_aggiunta.dart';
import '../../../components/libro_cover_widget.dart';
import '../../../models/libreria_model.dart';
import '../../../services/controllers/homepage_controller.dart';
import 'package:provider/provider.dart';

import '../../dettagli_libro/dettagli_libro_view.dart';

/// Tab principale della homepage dell'app.
/// Mostra un header di benvenuto, pulsante per aggiungere libri, pulsanti rapidi e caroselli di libri consigliati e ultime aggiunte.
class HomepageTab extends StatefulWidget {
  /// Costruttore della tab Homepage.
  const HomepageTab({super.key});

  @override
  State<HomepageTab> createState() => _HomepageTabState();
}

class _HomepageTabState extends State<HomepageTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final libreria = context.watch<Libreria>();
    final controller = HomepageController(libreria);

    return SingleChildScrollView(
      child: Column(
        spacing: 15,
        children: <Widget>[
          _buildHeader(context),
          _buildBody(context, controller),
        ],
      ),
    );
  }

  /// Costruisce l'header della homepage con titolo, pulsante aggiunta e stile personalizzato.
  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(70),
              bottomLeft: Radius.circular(150),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
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
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                child: Text(
                  "Benvenuto su Bibliotech!",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => const PopupAggiunta(),
                    );
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

  /// Costruisce il corpo della homepage con pulsanti rapidi, carosello libri consigliati e ultime aggiunte.
  Widget _buildBody(BuildContext context, HomepageController controller) {
    final libriConsigliati = controller.libriConsigliati;
    final ultimeAggiunte = controller.ultimeAggiunte;
    final citazione = controller.citazioneDelGiorno;

    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    citazione.testo,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic
                    )
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '- ${citazione.autore}, ${citazione.libro}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Text(
            "Libri consigliati",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 200,
            child:
                libriConsigliati.isEmpty
                    ? const Center(
                      child: Text("Nessun libro consigliato al momento."),
                    )
                    : CarouselView(
                      itemExtent: 150,
                      children:
                          libriConsigliati
                              .map(
                                (libro) => Container(
                                  width: 150,
                                  height: 150,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: LibroCoverWidget(libro: libro),
                                ),
                              )
                              .toList(),
                      onTap: (int index) {
                        final libro = libriConsigliati[index];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DettagliLibroView(libro: libro),
                          ),
                        );
                        debugPrint('Hai premuto il libro: ${libro.titolo}');
                      },
                    ),
          ),
          const Text(
            "Ultime aggiunte",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 200,
            child:
                ultimeAggiunte.isEmpty
                    ? const Center(child: Text("Nessuna aggiunta recente."))
                    : CarouselView(
                      itemExtent: 150,
                      children:
                          ultimeAggiunte
                              .map(
                                (libro) => Container(
                                  width: 150,
                                  height: 150,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: LibroCoverWidget(libro: libro),
                                ),
                              )
                              .toList(),
                      onTap: (int index) {
                        final libro = ultimeAggiunte[index];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DettagliLibroView(libro: libro),
                          ),
                        );
                        debugPrint('Hai premuto il libro: ${libro.titolo}');
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
