// views/ricerca_google_books_view.dart

import 'package:flutter/material.dart';
import '../../services/controllers/aggiungi_libro_api_controller.dart';
import '../../components/libro_cover_widget.dart';

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
  }

  @override
  void dispose() {
    controller.removeListener();
    controller.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
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
                        final book = controller.searchResults[index];
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
                              // Quando l'utente clicca, torna indietro passando il libro selezionato
                              Navigator.pop(context, book);
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
