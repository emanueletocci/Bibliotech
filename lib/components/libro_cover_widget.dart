// lib/components/book_cover_display.dart
import 'package:flutter/material.dart';
import '../models/libro.dart'; // Assicurati che il percorso sia corretto
import 'dart:io'; // Per l'uso di File

class LibroCoverWidget extends StatelessWidget {
  final Libro libro;

  const LibroCoverWidget({super.key, required this.libro});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0), 
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
      } else if(libro.copertina == 'assets/images/book_placeholder.jpg') {
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
