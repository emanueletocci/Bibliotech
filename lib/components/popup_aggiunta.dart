import 'package:bibliotech/screens/aggiungi_libro/aggiunta_modifica_manuale_view.dart';
import 'package:flutter/material.dart';
import '../screens/ricerca_api/ricerca_google_books_view.dart';

class PopupAggiunta extends StatelessWidget {
  const PopupAggiunta({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final mediaQuery = MediaQuery.of(context);
        final screenHeight = mediaQuery.size.height;
        final screenWidth = mediaQuery.size.width;

        double popupHeight;
        double popupWidth;
        double buttonWidth;

        // Calcolo dimensioni in base all'orientamento
        if (orientation == Orientation.portrait) {
          popupHeight = screenHeight * 0.7;
          popupWidth = screenWidth * 0.9;
          buttonWidth = popupWidth * 0.9;
        } else {
          popupHeight = screenHeight * 0.8;
          popupWidth = screenWidth * 0.7;
          buttonWidth = popupWidth * 0.9;
        }

        return Container(
          constraints: BoxConstraints(
            maxHeight: popupHeight,
            maxWidth: popupWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              spacing: 15,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Aggiungi un nuovo libro',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                _buildButton(
                  'Cerca nel catalogo',
                  Icons.search,
                  buttonWidth,
                  () async {
                    final result = await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RicercaGoogleBooksView()));
                    if (result != null && result == true) {
                      Navigator.of(context).pop(true); // Chiude il popup e ritorna true
                    }
                  },
                ),
                _buildButton(
                  'Aggiungi manualmente',
                  Icons.add,
                  buttonWidth,
                  () async {
                    final result = await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AggiuntaModificaLibroManualeView()));
                    if (result != null && result == true) {
                      Navigator.of(context).pop(true); // Chiude il popup e ritorna true
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton(String text, IconData icon, double width, VoidCallback onPressed) {
    return SizedBox(
      width: width,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(text),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
        ),
      ),
    );
  }
}
