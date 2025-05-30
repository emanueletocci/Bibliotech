import 'package:bibliotech/screens/dettagli_libro/dettagli_libro_view.dart';
import 'package:flutter/material.dart';
import '../../components/libro_cover_widget.dart';
import '../../services/controllers/ricerca_google_books_controller.dart';

/// Schermata per la ricerca di libri tramite Google Books API.
/// Permette all'utente di cercare libri per titolo o ISBN e visualizzare i risultati.
/// Toccando un risultato si accede ai dettagli del libro.
class RicercaGoogleBooksView extends StatefulWidget {
  /// Costruttore della schermata di ricerca Google Books.
  const RicercaGoogleBooksView({super.key});

  @override
  State<RicercaGoogleBooksView> createState() => _RicercaGoogleBooksViewState();
}

class _RicercaGoogleBooksViewState extends State<RicercaGoogleBooksView> {
  /// Controller per la gestione della ricerca e dei risultati.
  late RicercaGoogleBooksController controller;

  /// Flag per evitare di inizializzare più volte il controller.
  bool _isControllerInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isControllerInitialized) {
      controller = RicercaGoogleBooksController();
      _isControllerInitialized = true;
    }
  }

  /// Gestisce la ricerca dei libri e mostra eventuali errori tramite SnackBar.
  Future<void> _handleSearchBooks() async {
    try {
      await controller.searchBooks();
    } catch (e) {
      String errorMessage = e.toString();
      const prefix = 'Exception: ';
      if (errorMessage.startsWith(prefix)) {
        errorMessage = errorMessage.substring(prefix.length);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cerca su Google Books'),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                            _handleSearchBooks();
                          },
                        ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
              onSubmitted: (_) {
                _handleSearchBooks();
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.builder(
                itemCount: controller.searchResults.length,
                itemBuilder: (context, index) {
                  final book = controller.searchResults[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    elevation: 2,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DettagliLibroView(libro: book),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
