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

  // Metodo per gestire la ricerca dei libri. Ora gestisce setState e i messaggi.
  Future<void> _handleSearchBooks() async {
    setState(() {});
    try {
      // Esegui la ricerca nel controller e attendi il suo completamento.
      await controller.searchBooks();

    } catch (e) {
      // Cattura l'eccezione lanciata dal controller e mostra un messaggio di errore.
      String errorMessage = e.toString();
      const prefix = 'Exception: ';
      if (errorMessage.startsWith(prefix)) {
        // Rimuovo il prefisso "Exception: " dal messaggio di errore
        errorMessage = errorMessage.substring(prefix.length);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {});
    }
  }

  // Metodo che gestisce l'aggiunta del libro (fornito dall'API) alla libreria
  void _handleAggiungiLibro(Libro libroDaAggiungere) {
    try {
      controller.handleAggiungi(libroDaAggiungere);
      // Se handleAggiungi() viene eseguito senza errori, mostro uno SnackBar di successo.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Libro inserito correttamente!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Cattura l'eccezione lanciata dal controller e mostra un messaggio di errore.
      String errorMessage = e.toString();
      const prefix = 'Exception: ';
      if (errorMessage.startsWith(prefix)) {
        errorMessage = errorMessage.substring(prefix.length);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {});
      }
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
                labelText: 'Cerca per titolo or ISBN',
                suffixIcon: controller.isLoading
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
                        _handleAggiungiLibro(book);
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
