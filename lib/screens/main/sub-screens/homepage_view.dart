import 'package:flutter/material.dart';
import '../../../components/popup_aggiunta.dart';
import '../../../components/libro_cover_widget.dart';
import '../../../models/libreria_model.dart';
import '../../../services/controllers/homepage_controller.dart';
import 'package:provider/provider.dart';
import '../../dettagli_libro/dettagli_libro_view.dart';

/// Schermata principale dell'applicazione Bibliotech.
///
/// Mostra:
/// - header di benvenuto con pulsante per aggiungere libri,
/// - citazione del giorno,
/// - caroselli di libri consigliati e delle ultime aggiunte.
class HomepageView extends StatefulWidget {
  /// Costruttore della tab Homepage.
  const HomepageView({super.key});

  @override
  State<HomepageView> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView> {
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
        /// Spaziatura verticale tra i componenti principali.
        spacing: 15,
        children: <Widget>[
          _buildHeader(context),
          _buildBody(context, controller),
        ],
      ),
    );
  }

  /// Costruisce l'header della homepage.
  ///
  /// Include:
  /// - testo di benvenuto,
  /// - pulsante per aggiungere un nuovo libro tramite popup,
  /// - sfondo colorato con bordi personalizzati.
  Widget _buildHeader(BuildContext context) {
    final orientamento = MediaQuery.of(context).orientation;
    final headerHeight = orientamento == Orientation.portrait ? 250.0 : 180.0;
    final headerPadding = orientamento == Orientation.portrait ? 20.0 : 0.0;
    final headerSpacing = orientamento == Orientation.portrait ? 25.0 : 10.0;

    return Stack(
      children: <Widget>[
        /// Sfondo con curvatura e ombra.
        Container(
          height: headerHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(70),
              bottomLeft: Radius.circular(150),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 1,
                blurRadius: 15,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),

        /// Testo e pulsante di aggiunta.
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: headerPadding),
          child: Column(
            spacing: headerSpacing,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SafeArea(
                child: Text(
                  "Benvenuto su Bibliotech!",
                  style: TextStyle(
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

  /// Costruisce il corpo della homepage.
  ///
  /// Contiene:
  /// - citazione del giorno,
  /// - carosello con libri consigliati,
  /// - carosello con ultime aggiunte.
  Widget _buildBody(BuildContext context, HomepageController controller) {
    final libriConsigliati = controller.libriConsigliati;
    final ultimeAggiunte = controller.ultimeAggiunte;
    final citazione = controller.citazioneDelGiorno;

    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /// Card con la citazione del giorno.
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    citazione.testo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
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

          /// Titolo e carosello dei libri consigliati.
          const Text(
            "Libri consigliati",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 200,
            child: libriConsigliati.isEmpty
                ? const Center(
                    child: Text("Nessun libro consigliato al momento."),
                  )
                : CarouselView(
                    itemExtent: 150,
                    children: libriConsigliati
                        .map(
                          (libro) => Container(
                            width: 150,
                            height: 150,
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: LibroCoverWidget(libro: libro),
                          ),
                        )
                        .toList(),
                    onTap: (int index) {
                      final libro = libriConsigliati[index];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DettagliLibroView(libro: libro),
                        ),
                      );
                      debugPrint('Hai premuto il libro: ${libro.titolo}');
                    },
                  ),
          ),

          /// Titolo e carosello delle ultime aggiunte.
          const Text(
            "Ultime aggiunte",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 200,
            child: ultimeAggiunte.isEmpty
                ? const Center(child: Text("Nessuna aggiunta recente."))
                : CarouselView(
                    itemExtent: 150,
                    children: ultimeAggiunte
                        .map(
                          (libro) => Container(
                            width: 150,
                            height: 150,
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: LibroCoverWidget(libro: libro),
                          ),
                        )
                        .toList(),
                    onTap: (int index) {
                      final libro = ultimeAggiunte[index];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DettagliLibroView(libro: libro),
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
