import 'package:bibliotech/screens/aggiungi_libro/aggiunta_modifica_manuale_view.dart';
import 'package:flutter/material.dart';
import '../screens/ricerca_api/ricerca_google_books_view.dart';

/// Widget popup per la selezione della modalità di aggiunta di un nuovo libro.
/// Permette di scegliere tra ricerca tramite catalogo o aggiunta manuale.
class PopupAggiunta extends StatelessWidget {
  /// Costruttore della classe [PopupAggiunta].
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
              /// Spaziatura verticale tra i pulsanti e il titolo.
              spacing: 15,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Titolo del popup.
                const Text(
                  'Aggiungi un nuovo libro',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                /// Pulsante per la ricerca nel catalogo.
                _buildButton(
                  'Cerca nel catalogo',
                  Icons.search,
                  buttonWidth,
                  () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => RicercaGoogleBooksView(),
                    ),
                  ),
                ),

                /// Pulsante per l'aggiunta manuale.
                _buildButton(
                  'Aggiungi manualmente',
                  Icons.add,
                  buttonWidth,
                  () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => AggiuntaModificaLibroManualeView(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Costruisce un pulsante con icona e testo per il popup.
  ///
  /// [text] è il testo del pulsante.
  /// [icon] è l'icona da visualizzare.
  /// [width] è la larghezza del pulsante.
  /// [onPressed] è la callback da eseguire al click.
  Widget _buildButton(
    String text,
    IconData icon,
    double width,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: width,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(text),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      ),
    );
  }
}
