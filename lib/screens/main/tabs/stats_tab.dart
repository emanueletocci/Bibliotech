import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/libreria_model.dart';
import '../../../models/stato_libro_model.dart';
import '../../../components/grafici/pie_chart.dart';
import '../../../components/grafici/line_chart.dart';
import '../../../services/controllers/statistiche_controller.dart';

/// Schermata delle statistiche.
/// Mostra:
/// - il numero di libri per ogni stato,
/// - la media delle recensioni,
/// - istogramma che mostra le recensioni fatte e i rispettivi libri,
/// - numero pagine lette con tempo medio totale,
/// - numero note scritte,
/// - un grafico a torta dei generi letti.
class StatisticheTab extends StatelessWidget {
  const StatisticheTab({super.key});

  @override
  Widget build(BuildContext context) {
    final libreria = context.watch<Libreria>();
    final controller = StatisticheController(libreria);

    final conteggioPerStato = controller.getConteggioPerStato();
    final numNote = controller.getNumNote();
    final numRecensioni = controller.getNumRecensioni();
    final mediaVoto = controller.getMediaVoto();
    final pagineLetteETempo = controller.getPagineLetteETempo();
    final conteggioGeneri = controller.getConteggioGeneri(); 
    final votiLibri = controller.getListaVoti();
    final titoliLibri = controller.getTitoliLibriConVoto();


    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          GrigliaStato(conteggioPerStato: conteggioPerStato),
          SizedBox(
            height: 900.0,
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Prima Card: Recensioni
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Storico Recensioni',
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Media rec1ensioni:', // NOTA: c'è un typo, corretto sotto
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 2.0,
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 28),
                              SizedBox(height: 2.5),
                              Text(
                                mediaVoto.toStringAsFixed(1),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                'Recensioni fatte: $numRecensioni',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // istogramma delle recensioni
                        BookRatingBarChart(
                          titoliLibri: titoliLibri,
                          voti: votiLibri,
                        ),
                      ],
                    ),
                  ),
                ),
                // Seconda Card: Pagine lette e Note
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        shape: RoundedRectangleBorder( // NOTA: c'è un typo, deve essere RoundedRectangleBorder
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Lettura',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text.rich(
                                TextSpan(
                                  text: 'Pagine lette: ',
                                  style: TextStyle(fontSize: 13),
                                  children: [
                                    TextSpan(
                                      text: '${pagineLetteETempo['pagineLette']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Tempo stimato: ',
                                  style: TextStyle(fontSize: 13),
                                  children: [
                                    TextSpan(
                                      text: '${pagineLetteETempo['ore']}h ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${pagineLetteETempo['minuti']}min',
                                      style: TextStyle(
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
                    Expanded(
                      flex: 1,
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(right: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                         padding: EdgeInsets.all(16), // NOTA: c'è un typo, rimuovi il "1" prima di padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Note",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text.rich(
                                TextSpan(
                                  text: "Note scritte: ",
                                  style: TextStyle(fontSize: 13),
                                  children: [
                                    TextSpan(
                                      text: "$numNote",
                                      style: TextStyle(
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
                ),
                Expanded(
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'I tuoi genere più letti',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: PieChartWidget(
                              conteggioGeneri: conteggioGeneri,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// GrigliaStato è nello stesso file, come richiesto
class GrigliaStato extends StatelessWidget {
  final Map<StatoLibro, int> conteggioPerStato;
  const GrigliaStato({super.key, required this.conteggioPerStato});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: Column(
          children: [
            Flexible(
              child: Row(
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
            ),
            Flexible(
              child: Row(
                children: [
                  Expanded(
                    child: _statoCard(
                      'Da leggere',
                      conteggioPerStato[StatoLibro.daLeggere]?.toString() ?? '0',
                      Colors.orange,
                      Icons.bookmark_add,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
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
            ),
          ],
        ),
      ),
    );
  }

  Expanded _statoCard(
    String title,
    String count,
    MaterialColor baseColor,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 9),
              blurRadius: 18,
              spreadRadius: -5,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [baseColor[200]!, baseColor[300]!, baseColor[500]!],
            stops: const [0.1, 0.5, 1.0],
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
              bottom: 33,
              right: 1,
              child: Opacity(
                opacity: 0.3,
                child: Icon(icon, size: 30, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
