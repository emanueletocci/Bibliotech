import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/genere_libro_model.dart';

/// Widget che visualizza un grafico a torta con i generi dei libri letti.
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
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                touchedIndex =
                    (pieTouchResponse?.touchedSection?.touchedSectionIndex ??
                        -1);
              });
            },
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 0,
          sections: _showingSections(widget.conteggioGeneri),
        ),
      ),
    );
  }

  /// Genera le sezioni di un grafico a torta per la distribuzione dei generi.
  /// Calcola la percentuale di ogni genere rispetto al totale, assegna un colore
  /// e determina la dimensione della sezione in base all'interazione utente.
  List<PieChartSectionData> _showingSections(
    Map<GenereLibro, int> conteggioGeneri,
  ) {
    final totale = conteggioGeneri.values.fold<int>(0, (a, b) => a + b);
    final List<Color> colori = Colors.primaries;

    List<PieChartSectionData> sezioni = [];
    int index = 0;

    for (var genereNum in conteggioGeneri.entries) {
      final isTouched = index == touchedIndex;
      final percentuale = (genereNum.value / totale) * 100;
      final colore = colori[index % colori.length];

      sezioni.add(
        PieChartSectionData(
          color: colore,
          value: genereNum.value.toDouble(),
          title: "${genereNum.key.titolo}\n${percentuale.toStringAsFixed(1)}%",
          radius: isTouched ? 80 : 70,
          titleStyle: TextStyle(
            fontSize: isTouched ? 14 : 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

      index++;
    }

    return sezioni;
  }
}
