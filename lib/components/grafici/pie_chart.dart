import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/genere_libro_model.dart';

/// Widget che visualizza un grafico a torta con i generi dei libri letti
/// e una legenda sottostante che mostra i generi e la percentuale letta.
class PieChartWidget extends StatefulWidget {
  /// Mappa che contiene i generi dei libri come chiave e il conteggio come valore.
  final Map<GenereLibro, int> conteggioGeneri;

  /// Costruttore del widget [PieChartWidget].
  const PieChartWidget({super.key, required this.conteggioGeneri});

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  /// Indice della sezione attualmente toccata nel grafico.
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.conteggioGeneri.isEmpty) {
      return Center(
        child: Text(
          "Non hai letto nessun libro! Inizia a leggere qualcosa!",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    final orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.landscape) {
      // Layout orizzontale: grafico e legenda affiancati
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PieChart(
                PieChartData(
                  sectionsSpace: 1,
                  centerSpaceRadius: 0,
                  sections: _showingSections(widget.conteggioGeneri),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildLegenda(widget.conteggioGeneri),
            ),
          ),
        ],
      );
    } else {
      // Layout verticale classico: grafico sopra, legenda sotto
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.3,
            child: PieChart(
              PieChartData(
                sectionsSpace: 1,
                centerSpaceRadius: 0,
                sections: _showingSections(widget.conteggioGeneri),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: _buildLegenda(widget.conteggioGeneri),
          ),
        ],
      );
    }
  }

  /// Crea le sezioni del grafico a torta in base al conteggio dei generi.
  /// Ogni sezione ha un colore assegnato e dimensioni diverse se selezionata.
  List<PieChartSectionData> _showingSections(
    Map<GenereLibro, int> conteggioGeneri,
  ) {
    // fold accumula il totale dei libri letti per calcolare le percentuali.
    conteggioGeneri.values.fold<int>(0, (a, b) => a + b);
    final List<Color> colori = Colors.primaries;

    List<PieChartSectionData> sezioni = [];
    int index = 0;

    for (var entry in conteggioGeneri.entries) {
      final isTouched = index == touchedIndex;
      final colore = colori[index % colori.length];

      sezioni.add(
        PieChartSectionData(
          color: colore,
          value: entry.value.toDouble(),
          title: '', // Nessun titolo all'interno della sezione.
          radius: isTouched ? 80 : 70,
        ),
      );

      index++;
    }

    return sezioni;
  }

  /// Costruisce la legenda sottostante il grafico a torta.
  /// Ogni voce mostra un colore, il nome del genere e la percentuale corrispondente.
  Widget _buildLegenda(Map<GenereLibro, int> conteggioGeneri) {
    final totale = conteggioGeneri.values.fold<int>(0, (a, b) => a + b);
    final List<Color> colori = Colors.primaries;

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children:
          conteggioGeneri.entries.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final genere = entry.value.key;
            final valore = entry.value.value;
            final colore = colori[index % colori.length];
            final percentuale = (valore / totale) * 100;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 12, height: 12, color: colore),
                const SizedBox(width: 6),
                Text(
                  '${genere.titolo} (${percentuale.toStringAsFixed(1)}%)',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }).toList(),
    );
  }
}
