import 'package:flutter/material.dart';
import '../models/libro_model.dart';
import 'dart:io';

/// Widget che visualizza la copertina di un libro.
/// Gestisce copertine da asset, URL di rete o file locali.
/// Mostra un'icona di errore se l'immagine non è disponibile o non valida.
class LibroCoverWidget extends StatelessWidget {
  /// Il libro di cui mostrare la copertina.
  final Libro libro;

  /// Callback opzionale da eseguire al tap sulla copertina.
  final VoidCallback? onTap;

  /// Costruttore del widget [LibroCoverWidget].
  const LibroCoverWidget({super.key, required this.libro, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: _buildCoverImage(),
    );
  }

  /// Metodo helper per costruire l'immagine della copertina.
  /// Gestisce asset di default, URL di rete e file locali.
  Widget _buildCoverImage() {
    // Caso 1: La copertina è null o vuota, o è il placeholder di default.
    // Se la copertina è null, la tratto come un placeholder
    if (libro.copertina == null ||
        libro.copertina!.isEmpty ||
        libro.copertina == 'assets/images/book_placeholder.jpg') {
      return Image.asset(
        'assets/images/book_placeholder.jpg',
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) => const Center(
              child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
            ),
      );
    }
    // Caso 2: La copertina è un URL di rete
    else if (libro.copertina!.startsWith('http://') ||
        libro.copertina!.startsWith('https://')) {
      return Image.network(
        libro.copertina!,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) => const Center(
              child: Icon(
                Icons.broken_image,
                size: 50,
                color: Colors.red,
              ), // Per immagini di rete rotte
            ),
      );
    }
    // Caso 3: Altrimenti, è un percorso di file locale
    else {
      return Image.file(
        File(libro.copertina!),
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) => const Center(
              child: Icon(
                Icons.broken_image,
                size: 50,
                color: Colors.red,
              ), // Per immagini locali rotte
            ),
      );
    }
  }
}
