enum StatoLibro {
  daLeggere('Da leggere'),
  inLettura ('In lettura'),
  letto ('Letto'),
  abbandonato ('Abbandonato'),
  daAcquistare('Da acquistare');

  final String titolo;

  const StatoLibro(this.titolo);

  @override
  String toString() {
    return titolo;
  }
}