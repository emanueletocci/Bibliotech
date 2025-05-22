import 'package:flutter/material.dart';
import '../models/libro.dart';
import 'dart:io';

class LibroCoverWidget extends StatelessWidget {
  final Libro libro;
  const LibroCoverWidget({super.key, required this.libro});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: _buildBookCover(libro),
      ),
    );
  }

  Widget _buildBookCover(Libro libro) {
    // Se la copertina è un URL di rete
    if (libro.copertina!.startsWith('http://') ||
        libro.copertina!.startsWith('https://')) {
      return Image.network(
        libro.copertina!,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) => const Center(
              child: Icon(Icons.broken_image, size: 50, color: Colors.red),
            ),
      );
    } else if (libro.copertina == 'assets/images/book_placeholder.jpg') {
      // Se la copertina è il placeholder di default
      return Image.asset(
        libro.copertina!,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) => const Center(
              child: Icon(Icons.broken_image, size: 50, color: Colors.red),
            ),
      );
    } else {
      // Altrimenti mostro il file locale
      return Image.file(
        File(libro.copertina!),
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) => const Center(
              child: Icon(Icons.broken_image, size: 50, color: Colors.red),
            ),
      );
    }
  }
}
