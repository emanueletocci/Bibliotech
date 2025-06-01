import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/genere_libro_model.dart';
import '../../../models/libreria_model.dart';
import '../../../models/stato_libro_model.dart';
import '../../../components/grafici/pie_chart.dart';
import '../../../components/grafici/line_chart.dart';
import '../../../services/controllers/statistiche_controller.dart';

/// Schermata delle statistiche della libreria.
/// Mostra:
/// - il numero di libri per ogni stato,
/// - la media e il numero delle recensioni,
/// - un grafico delle recensioni per libro,
/// - pagine lette e tempo stimato di lettura,
/// - numero di note scritte,
/// - due grafici a torta per i generi (letti e totali).
class StatisticheTab extends StatelessWidget {
  const StatisticheTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Ottiene i dati dalla libreria tramite il controller
    final libreria = context.watch<Libreria>();
    final controller = StatisticheController(libreria);

    final conteggioPerStato = controller.getConteggioPerStato();
    final numNote = controller.getNumNote();
    final numRecensioni = controller.getNumRecensioni();
    final mediaVoto = controller.getMediaVoto();
    final pagineLetteETempo = controller.getPagineLetteETempo();
    final conteggioGeneriLetti = controller.getConteggioGeneriLetti();
    final conteggioGeneriTotale = controller.getConteggioGeneriTotali();
    final votiLibri = controller.getListaVoti();
    final titoliLibri = controller.getTitoliLibriConVoto();

    final orientamento = MediaQuery.of(context).orientation;
    final chartBoxHeight = orientamento == Orientation.portrait ? 350.0 : 150.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GrigliaStato(conteggioPerStato: conteggioPerStato),
          _buildRecensioniCard(
            mediaVoto,
            numRecensioni,
            titoliLibri,
            votiLibri,
          ),
          _buildLetturaENoteCard(pagineLetteETempo, numNote),
          _buildGeneriLettiCard(conteggioGeneriLetti, chartBoxHeight),
          _buildGeneriTuttiCard(conteggioGeneriTotale, chartBoxHeight),
        ],
      ),
    );
  }

  /// Costruisce una card con le statistiche sulle recensioni,
  /// mostrando media, numero e un grafico a linee.
  Widget _buildRecensioniCard(
    double mediaVoto,
    int numRecensioni,
    List<String> titoliLibri,
    List<double> votiLibri,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Storico Recensioni',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Media recensioni:', style: const TextStyle(fontSize: 12.0)),
            Column(
              spacing: 5,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 28),
                Text(
                  mediaVoto.toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Recensioni fatte: $numRecensioni',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            BookRatingBarChart(titoliLibri: titoliLibri, voti: votiLibri),
          ],
        ),
      ),
    );
  }

  /// Costruisce due card affiancate:
  /// - Una con pagine lette e tempo stimato,
  /// - L'altra con il numero di note scritte.
  Widget _buildLetturaENoteCard(
    Map<String, dynamic> pagineLetteETempo,
    int numNote,
  ) {
    return Row(
      spacing: 15,
      children: [
        // Card: Lettura
        Expanded(
          flex: 2,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lettura',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'Pagine lette: ',
                      style: const TextStyle(fontSize: 13),
                      children: [
                        TextSpan(
                          text: '${pagineLetteETempo['pagineLette']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'Tempo stimato: ',
                      style: const TextStyle(fontSize: 13),
                      children: [
                        TextSpan(
                          text: '${pagineLetteETempo['ore']}h ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '${pagineLetteETempo['minuti']}min',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Card: Note
        Expanded(
          flex: 1,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Note",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Note scritte: ",
                      style: const TextStyle(fontSize: 13),
                      children: [
                        TextSpan(
                          text: "$numNote",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Card che mostra i generi **più letti** sotto forma di grafico a torta.
  Widget _buildGeneriLettiCard(
    Map<GenereLibro, int> conteggioGeneri,
    double chartBoxHeight,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'I tuoi generi più letti',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: chartBoxHeight,
              child: PieChartWidget(conteggioGeneri: conteggioGeneri),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card che mostra i generi di **tutti** i libri (non solo quelli letti).
Widget _buildGeneriTuttiCard(
  Map<GenereLibro, int> conteggioGeneri,
  double chartBoxHeight,
) {
  return Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tutti i tuoi generi',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: chartBoxHeight,
            child: PieChartWidget(conteggioGeneri: conteggioGeneri),
          ),
        ],
      ),
    ),
  );
}

/// Mostra una griglia con il numero di libri per ogni stato:
/// - Letto
/// - In lettura
/// - Da leggere
/// - Abbandonato
/// - Da acquistare
class GrigliaStato extends StatelessWidget {
  final Map<StatoLibro, int> conteggioPerStato;
  const GrigliaStato({super.key, required this.conteggioPerStato});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 12,
        children: [
          Row(
            spacing: 8,
            children: [
              _statoCard(
                'Letti',
                conteggioPerStato[StatoLibro.letto]?.toString() ?? '0',
                Colors.green,
                Icons.book_rounded,
              ),
              _statoCard(
                'In lettura',
                conteggioPerStato[StatoLibro.inLettura]?.toString() ?? '0',
                Colors.blue,
                Icons.incomplete_circle_rounded,
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              _statoCard(
                'Da leggere',
                conteggioPerStato[StatoLibro.daLeggere]?.toString() ?? '0',
                Colors.orange,
                Icons.bookmark_add,
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              _statoCard(
                'Abbandonati',
                conteggioPerStato[StatoLibro.abbandonato]?.toString() ?? '0',
                Colors.red,
                Icons.cancel_rounded,
              ),
              _statoCard(
                'Da acquistare',
                conteggioPerStato[StatoLibro.daAcquistare]?.toString() ?? '0',
                Colors.purple,
                Icons.add_shopping_cart_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Costruisce una card decorata per uno specifico stato libro.
  Expanded _statoCard(
    String title,
    String count,
    MaterialColor baseColor,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 9),
              blurRadius: 18,
              spreadRadius: -10,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [baseColor[200]!, baseColor[300]!, baseColor[500]!],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              child: Opacity(
                opacity: 0.2,
                child: Icon(icon, size: 30, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
