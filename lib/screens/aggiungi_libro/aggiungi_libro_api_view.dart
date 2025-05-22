// views/ricerca_google_books_view.dart

import 'package:flutter/material.dart';
// Mantengo il tuo import originale. Assicurati che AggiungiLibroApiController
// sia effettivamente la classe che hai rinominato da RicercaGoogleBooksController.
// Se non lo è, potresti avere un errore di tipo in runtime.
import '../../services/controllers/aggiungi_libro_api_controller.dart';
import '../../components/libro_cover_widget.dart';
import '../../screens/main_view.dart';
import '../../models/libro.dart'; // Importa il modello Libro, necessario per il tipo nel ListView.builder

class RicercaGoogleBooksView extends StatefulWidget {
  const RicercaGoogleBooksView({super.key});

  @override
  State<RicercaGoogleBooksView> createState() => _RicercaGoogleBooksViewState();
}

class _RicercaGoogleBooksViewState extends State<RicercaGoogleBooksView> {
  // Ho lasciato il nome del controller come 'controller' e l'istanza come 'AggiungiLibroApiController()'
  // basandomi sull'import che mi hai fornito.
  final RicercaGoogleBooksController controller =
      RicercaGoogleBooksController(); // Usando il nome del controller dal tuo import

  @override
  void initState() {
    super.initState();
    // Non ci sono più listeners da registrare qui.
    // L'UI si baserà su setState chiamato esplicitamente dopo le operazioni.
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Metodo per gestire la ricerca dei libri. Ora gestisce setState e i messaggi.
  Future<void> _handleSearchBooks() async {
    // Il controller aggiorna _isLoading a true e _searchResults a [],
    // quindi chiamiamo setState per riflettere questi cambiamenti immediatamente.
    setState(() {
      controller.searchBooks(); // La chiamata è già asincrona, ma qui la eseguiamo subito
    });

    try {
      await controller.searchBooks(); // Esegui la ricerca nel controller
      // Dopo la ricerca, aggiorniamo la UI per mostrare i risultati o il messaggio "Nessun risultato".
      // La logica di "Nessun libro trovato" è ora gestita dal controller rilanciando un'eccezione
      // o dal controllo sulla lunghezza di searchResults.
      if (controller.searchResults.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nessun libro trovato per la tua ricerca.'),
            backgroundColor: Colors.blueGrey, // Colore diverso per i messaggi informativi
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Cattura l'eccezione lanciata dal controller e mostra un messaggio di errore
      String errorMessage = e.toString();
      const prefix = 'Exception: ';
      if (errorMessage.startsWith(prefix)) {
        errorMessage = errorMessage.substring(prefix.length);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } finally {
      // Indipendentemente dal successo o dall'errore, _isLoading sarà false, quindi aggiorniamo la UI.
      setState(() {});
    }
  }


  // Metodo che gestisce il click del pulsante "Aggiungi" per un libro specifico dai risultati API
  // Ora gestisce setState, SnackBar e navigazione direttamente qui.
  void _handleAggiungiLibro(Libro libroDaAggiungere) async {
    try {
      await controller.handleAggiungi(libroDaAggiungere); // Chiama il metodo del controller
      // Se handleAggiungi() viene eseguito senza errori, mostro uno SnackBar di successo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Libro inserito correttamente!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      // Attendo 2 secondi prima di tornare alla schermata principale
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return; // Controllo se il widget è ancora montato

        Navigator.of(context).pushReplacement(
          // Usare pushReplacement per evitare di tornare alla pagina di aggiunta API
          MaterialPageRoute(builder: (context) => const MainScreen()),
        ); // torno alla schermata principale se non vengono lanciate eccezioni
      });
    } catch (e) {
      // Cattura l'eccezione lanciata dal controller e mostra un messaggio di errore
      String errorMessage = e.toString();
      const prefix = 'Exception: ';
      if (errorMessage.startsWith(prefix)) {
        errorMessage = errorMessage.substring(prefix.length);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } finally {
      // Aggiorniamo la UI per riflettere eventuali cambiamenti (anche se l'aggiunta non cambia i searchResults)
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
                labelText: 'Cerca per titolo o ISBN',
                suffixIcon: controller.isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          _handleSearchBooks(); // Chiamiamo il nuovo metodo che gestisce setState e messaggi
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
              onSubmitted: (_) {
                _handleSearchBooks(); // Chiamiamo il nuovo metodo che gestisce setState e messaggi
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
                              // Chiamiamo il metodo interno della View, passandogli il libro corrente
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