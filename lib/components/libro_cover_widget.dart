// lib/components/book_cover_display.dart
import 'package:flutter/material.dart';
import '../models/libro.dart'; // Assicurati che il percorso sia corretto
import 'dart:io'; // Per l'uso di File

class BookCoverDisplay extends StatelessWidget {
  final Libro libro;
  final double width; // Per controllare la larghezza dell'elemento nel carosello
  final double height; // Per controllare l'altezza dell'elemento nel carosello

  const BookCoverDisplay({
    super.key,
    required this.libro,
    this.width = 100, // Larghezza predefinita se non specificata
    this.height = 150, // Altezza predefinita
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 8.0), 
      decoration: BoxDecoration(
        color: Colors.grey[200], 
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: _buildCoverImage(context),
      ),
    );
  }

  Widget _buildCoverImage(BuildContext context) {
    if (libro.copertina != null && libro.copertina!.isNotEmpty) {
      // Controlla se il percorso è un URL di rete o un percorso locale
      if (libro.copertina!.startsWith('http://') || libro.copertina!.startsWith('https://')) {
        return Image.network(
          libro.copertina!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Placeholder in caso di errore di caricamento della rete
            return _buildErrorPlaceholder(context, 'Errore caricamento immagine');
          },
        );
      } else {
        // Assume che sia un percorso locale
        return Image.file(
          File(libro.copertina!), // Richiede import 'dart:io'
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Placeholder in caso di errore di caricamento del file locale
            return _buildErrorPlaceholder(context, 'Immagine locale non trovata');
          },
        );
      }
    } else {
      // Placeholder se non c'è nessuna copertina specificata
      return _buildNoCoverPlaceholder(context);
    }
  }

  Widget _buildNoCoverPlaceholder(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.book, size: 40, color: Colors.grey),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                libro.titolo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder(BuildContext context, String message) {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.broken_image, size: 40, color: Colors.redAccent),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: Colors.redAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}