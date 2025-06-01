import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/genere_libro_model.dart';

/// Widget che visualizza un grafico a torta con i generi dei libri letti e una legenda sottostante.
class PieChartWidget extends StatefulWidget {
  final Map<GenereLibro, int> conteggioGeneri;

  const PieChartWidget({super.key, required this.conteggioGeneri});

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.conteggioGeneri.isEmpty) {
      return Center(
        child: Text(
          "Inizia a leggere solo così potrai vedere i tuoi generi preferiti!",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1.3,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    touchedIndex =
                        pieTouchResponse?.touchedSection?.touchedSectionIndex ??
                        -1;
                  });
                },
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 0,
              sections: _showingSections(widget.conteggioGeneri),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildLegenda(widget.conteggioGeneri),
      ],
    );
  }

  /// Crea le sezioni del grafico a torta.
  List<PieChartSectionData> _showingSections(
    Map<GenereLibro, int> conteggioGeneri,
  ) {
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
          title: '', // Nessun titolo dentro la torta
          radius: isTouched ? 80 : 70,
        ),
      );

      index++;
    }

    return sezioni;
  }

  /// Costruisce la legenda con colori, nome del genere e percentuale.
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
