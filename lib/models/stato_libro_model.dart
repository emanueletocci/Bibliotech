import 'package:flutter/material.dart';

/// Enum che rappresenta lo stato di un libro nella libreria.
/// Ogni stato ha un titolo descrittivo e un'icona associata.
enum StatoLibro {
  /// Libro da leggere.
  daLeggere('Da leggere'),

  /// Libro attualmente in lettura.
  inLettura('In lettura'),

  /// Libro già letto.
  letto('Letto'),

  /// Libro abbandonato.
  abbandonato('Abbandonato'),

  /// Libro da acquistare.
  daAcquistare('Da acquistare');

  /// Titolo descrittivo dello stato.
  final String titolo;

  /// Costruttore dell'enum [StatoLibro] con titolo associato.
  const StatoLibro(this.titolo);

  /// Restituisce l'icona associata allo stato del libro.
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

  /// Restituisce il titolo descrittivo dello stato.
  @override
  String toString() {
    return titolo;
  }
}
