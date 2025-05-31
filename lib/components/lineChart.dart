import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Grafico a barre per visualizzare i voti assegnati ai libri.
// Ogni barra rappresenta un libro recensito, con tooltip al tocco.
class BookRatingBarChart extends StatefulWidget {
  //stateful perche serve per cambiare visivamente la barra selezionata al tocco
  final List<String> titoliLibri;
  final List<double> voti;

  const BookRatingBarChart({
    super.key,
    required this.titoliLibri,
    required this.voti,
  });
  @override
  State<BookRatingBarChart> createState() => _BookRatingBarChartState();
}

class _BookRatingBarChartState extends State<BookRatingBarChart> {
  // Indice della barra attualmente toccata (usato per evidenziare e tooltip).
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            maxY: 5,
            minY: 0,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => Colors.deepPurple,
                tooltipPadding: const EdgeInsets.all(8),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final titolo =
                      widget.titoliLibri[group
                          .x]; //group.x rappresenta l'indice della barra toccata. Quindi recupero l'indice e restituisco il titolo del libro passato al widget
                  return BarTooltipItem(
                    titolo,
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              touchCallback: (event, response) {
                setState(() {
                  touchedIndex = response?.spot?.touchedBarGroupIndex ?? -1;
                });
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => const SizedBox.shrink(),
                  reservedSize: 32,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 28,
                  getTitlesWidget:
                      (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: const FlGridData(show: true),
            barGroups: List.generate(widget.voti.length, (i) {
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: widget.voti[i],
                    width: 18,
                    color:
                        touchedIndex == i
                            ? Colors.deepPurple
                            : Colors.purple.shade200,
                    borderRadius: BorderRadius.circular(6),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 5,
                      color: Colors.purple.shade50,
                    ),
                  ),
                ],
                showingTooltipIndicators: touchedIndex == i ? [0] : [],
              );
            }),
          ),
        ),
      ),
    );
  }
}
