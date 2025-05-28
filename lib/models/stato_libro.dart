import 'package:flutter/material.dart';

enum StatoLibro {
  daLeggere('Da leggere'),
  inLettura('In lettura'),
  letto('Letto'),
  abbandonato('Abbandonato'),
  daAcquistare('Da acquistare');

  final String titolo;

  const StatoLibro(this.titolo);

  // Assegno qui un'icona per ogni stato del libro. Il metodo restituisce l'icona corrispondente
  IconData get icona {
    switch (this) {
      case StatoLibro.daLeggere:
        return Icons.bookmark;
      case StatoLibro.inLettura:
        return Icons.book;
      case StatoLibro.letto:
        return Icons.check;
      case StatoLibro.abbandonato:
        return Icons.cancel;
      case StatoLibro.daAcquistare:
        return Icons.shopping_cart;
    }
  }

  @override
  String toString() {
    return titolo;
  }
}
