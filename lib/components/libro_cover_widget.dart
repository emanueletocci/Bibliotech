import 'package:flutter/material.dart';
import '../models/libro.dart';
import 'dart:io';

class LibroCoverWidget extends StatelessWidget {
  final Libro libro;
  const LibroCoverWidget({super.key, required this.libro});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: _buildCoverImage(), // Chiamiamo il metodo senza passare il libro, dato che è un membro della classe
    );
  }

  // Metodo helper per costruire l'immagine della copertina
  Widget _buildCoverImage() {
    // Caso 1: La copertina è null o vuota, o è il placeholder di default.
    // Se la copertina è null, la tratto come un placeholder
    if (libro.copertina == null || libro.copertina!.isEmpty || libro.copertina == 'assets/images/book_placeholder.jpg') {
      return Image.asset(
        'assets/images/book_placeholder.jpg',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.broken_image, size: 50, color: Colors.grey), // Meno drammatico per i placeholder
        ),
      );
    }
    // Caso 2: La copertina è un URL di rete
    else if (libro.copertina!.startsWith('http://') || libro.copertina!.startsWith('https://')) {
      return Image.network(
        libro.copertina!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.broken_image, size: 50, color: Colors.red), // Per immagini di rete rotte
        ),
      );
    }
    // Caso 3: Altrimenti, è un percorso di file locale
    else {
      return Image.file(
        File(libro.copertina!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.broken_image, size: 50, color: Colors.red), // Per immagini locali rotte
        ),
      );
    }
  }
}