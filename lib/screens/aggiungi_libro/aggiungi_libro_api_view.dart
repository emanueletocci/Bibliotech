// views/ricerca_google_books_view.dart

import 'package:flutter/material.dart';
import '../../services/controllers/aggiungi_libro_api_controller.dart'; 
import '../../components/libro_cover_widget.dart'; 
import '../../screens/main_view.dart';
import '../../models/libro.dart'; 

class RicercaGoogleBooksView extends StatefulWidget {
  const RicercaGoogleBooksView({super.key});

  @override
  State<RicercaGoogleBooksView> createState() => _RicercaGoogleBooksViewState();
}

class _RicercaGoogleBooksViewState extends State<RicercaGoogleBooksView> {
  final RicercaGoogleBooksController controller =
      RicercaGoogleBooksController();

  @override
  void initState() {
    super.initState();
    controller.addListener(_onControllerUpdate);
    // NUOVO: Registra il listener per i messaggi (SnackBar) dal controller
    controller.addMessageListener((message, {bool isError = false}) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          duration: const Duration(seconds: 2), // Durata standard
        ),
      );
    });
  }

  @override
  void dispose() {
    controller.removeListener();
    controller.removeMessageListener(); // NUOVO: Rimuovi il listener dei messaggi
    controller.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  // MODIFICATO: Ora accetta un oggetto Libro come parametro
  void _handleAggiungiLibro(Libro libroToAdd) async { // Ho rinominato il parametro per chiarezza
    try {
      // Chiama il metodo del controller, passandogli il libro
      await controller.handleAggiungi(libroToAdd); // Ora handleAggiungi nel controller prende un Libro

      // Dopo l'aggiunta, potresti voler tornare indietro o fare altro.
      // Se il controller gestisce già i messaggi (SnackBar), non serve uno SnackBar qui.
      // La logica di navigazione dovrebbe essere qui se vuoi tornare indietro dopo l'aggiunta.
      // Per esempio, se l'aggiunta ha successo e vuoi tornare alla MainScreen:
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => const MainScreen()),
      // );

    } catch (e) {
      // Il controller dovrebbe già mostrare lo SnackBar di errore tramite _onShowMessage
      // Quindi, questo blocco catch potrebbe essere ridondante se il controller gestisce tutto.
      // Lo lascio per farti vedere che potresti ancora catturare errori specifici della UI qui.
      String errorMessage = e.toString();
      const prefix = 'Exception: ';
      if (errorMessage.startsWith(prefix)) {
        errorMessage = errorMessage.substring(prefix.length);
      }
      debugPrint('Errore catturato nella UI: $errorMessage'); // Usa debugPrint
      // Se il controller non gestisce lo SnackBar, lo faresti qui:
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cerca su Google Books'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: TextField(
              controller: controller.searchQueryController,
              decoration: InputDecoration(
                labelText: 'Cerca per titolo o ISBN',
                suffixIcon:
                    controller.isLoading
                        ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            controller.searchBooks();
                          },
                        ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
              onSubmitted: (_) {
                controller.searchBooks();
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Builder(
                builder: (BuildContext context) {
                  // PRIMA CONDIZIONE: Nessun risultato E non in caricamento
                  if (controller.searchResults.isEmpty &&
                      !controller.isLoading) {
                    return const Center(
                      child: Text('Nessun risultato. Inizia a cercare!'),
                    );
                  }
                  // SECONDA CONDIZIONE: È in caricamento
                  else if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // TERZA CONDIZIONE (ELSE): Ci sono risultati e non è in caricamento
                  else {
                    return ListView.builder(
                      itemCount: controller.searchResults.length,
                      itemBuilder: (context, index) {
                        final book = controller.searchResults[index]; // <--- IL LIBRO È QUI!
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          elevation: 2,
                          // ListTile consente di stilizzare i singoli elementi di una lista
                          child: ListTile(
                            leading: SizedBox(
                              width: 50,
                              height: 70,
                              child: LibroCoverWidget(libro: book),
                            ),
                            title: Text(
                              book.titolo,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              book.autori?.join(', ') ?? 'Autori sconosciuti',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              // MODIFICATO: Passa il libro cliccato al metodo _handleAggiungiLibro
                              _handleAggiungiLibro(book);
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}