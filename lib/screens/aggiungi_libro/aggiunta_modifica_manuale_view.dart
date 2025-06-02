import 'package:bibliotech/models/stato_libro_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../components/libro_cover_widget.dart';
import '../../components/feedback.dart';
import '../../models/genere_libro_model.dart';
import '../../models/libro_model.dart';
import '../../services/controllers/aggiunta/aggiunta_modifica_controller.dart';
import '../../models/libreria_model.dart';

/// Schermata per l'aggiunta o la modifica manuale di un libro.
/// Permette all'utente di inserire o modificare manualmente i dati di un libro,
/// inclusi titolo, autori, copertina, genere, stato, preferiti e altre informazioni.
class AggiuntaModificaLibroManualeView extends StatefulWidget {
  /// Libro da modificare, se presente. Se null, si tratta di una nuova aggiunta.
  final Libro? libroDaModificare;

  /// Costruttore della schermata di aggiunta/modifica manuale.
  const AggiuntaModificaLibroManualeView({super.key, this.libroDaModificare});

  @override
  State<AggiuntaModificaLibroManualeView> createState() =>
      _AggiuntaModificaLibroManualeViewState();
}

class _AggiuntaModificaLibroManualeViewState
    extends State<AggiuntaModificaLibroManualeView> {
  /// Controller per la logica di aggiunta/modifica manuale.
  late AggiuntaModificaController controller;

  /// Flag per evitare di inizializzare più volte il controller.
  bool _isControllerInitialized = false;

  /// Indica se il libro è segnato come preferito.
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = false; // Inizializzo lo stato del preferito a false
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isControllerInitialized) {
      final libreria = context.watch<Libreria>();
      controller = AggiuntaModificaController(
        libreria,
        widget.libroDaModificare,
      );
      _isControllerInitialized = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aggiungi un nuovo libro!"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Widget per la selezione della copertina del libro.
              Center(
                child: GestureDetector(
                  onTap: () async {
                    await controller.selezionaCopertina();
                    setState(() {
                      // Aggiorno lo stato per mostrare l'immagine selezionata
                    });
                  },
                  child: SizedBox(
                    width: 150,
                    height: 200,
                    child: LibroCoverWidget(
                      libro: Libro(
                        isbn: controller.isbnController.text,
                        copertina: controller.copertina,
                        titolo: '',
                      ),
                    ),
                  ),
                ),
              ),

              /// Icona per selezionare il libro come preferito.
              Center(
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: 35,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                      controller.isPreferito = isFavorite;
                    });
                  },
                ),
              ),

              /// Campo di testo per il titolo del libro.
              TextField(
                controller: controller.titoloController,
                decoration: const InputDecoration(labelText: 'Titolo*'),
              ),

              /// Campo di testo per gli autori.
              TextField(
                controller: controller.autoriController,
                decoration: const InputDecoration(labelText: 'Autori'),
              ),

              /// Campo di testo per il numero di pagine.
              TextField(
                controller: controller.numeroPagineController,
                decoration: const InputDecoration(labelText: 'Numero Pagine'),
                keyboardType: TextInputType.number,
              ),

              /// Dropdown per la selezione del genere.
              DropdownButtonFormField<GenereLibro>(
                decoration: const InputDecoration(labelText: 'Genere'),
                value: controller.genereSelezionato,
                items:
                    controller.generi
                        .map(
                          (genere) => DropdownMenuItem<GenereLibro>(
                            value: genere,
                            child: Text(genere.titolo),
                          ),
                        )
                        .toList(),
                onChanged: (val) {
                  setState(() {
                    controller.genereSelezionato = val;
                  });
                },
              ),

              /// Campo di testo per la lingua.
              TextField(
                controller: controller.linguaController,
                decoration: const InputDecoration(labelText: 'Lingua'),
                keyboardType: TextInputType.text,
              ),

              /// Campo di testo per la trama.
              TextField(
                controller: controller.tramaController,
                decoration: const InputDecoration(labelText: 'Trama'),
              ),

              /// Campo di testo per l'ISBN.
              TextField(
                controller: controller.isbnController,
                decoration: const InputDecoration(labelText: 'ISBN*'),
              ),

              /// Campo di testo per la data di pubblicazione.
              TextField(
                controller: controller.dataPubblicazioneController,
                decoration: const InputDecoration(
                  labelText: 'Data Pubblicazione',
                ),
                keyboardType: TextInputType.datetime,
              ),

              /// Campo di testo per il voto.
              TextField(
                controller: controller.votoController,
                decoration: const InputDecoration(labelText: 'Voto'),
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false, // non consento l'inserimento di voti negativi
                ),
                inputFormatters: <TextInputFormatter>[
                  // la stringa deve inizia con cifre seguite opzionalmente da un punto o una virgola e altre cifre
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*[,.]?\d*')),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    String text = newValue.text;

                    text = text.replaceAll(
                      ',',
                      '.',
                    ); // Sostituisco il punto con la virgola

                    // se l'utente inserisce un voto del tipo .5, lo trasformo in 0.5
                    if (text.startsWith('.') && text.length > 1) {
                      text = '0$text';
                    }
                    //.copyWith é un costruttore di copia che consente di creare un nuovo oggetto a partire da uno esistente,
                    return newValue.copyWith(
                      text: text, // aggiorno il testo
                      selection: TextSelection.collapsed(offset: text.length),
                    );
                  }),
                ],
              ),

              /// Campo di testo per le note personali.
              TextField(
                controller: controller.noteController,
                decoration: const InputDecoration(labelText: 'Note personali'),
              ),

              /// Dropdown per la selezione dello stato del libro.
              DropdownButtonFormField<StatoLibro>(
                decoration: const InputDecoration(labelText: 'Stato'),
                value: controller.statoSelezionato,
                items:
                    controller.stati
                        .map(
                          (stato) => DropdownMenuItem<StatoLibro>(
                            value: stato,
                            child: Text(stato.titolo),
                          ),
                        )
                        .toList(),
                onChanged: (val) {
                  setState(() {
                    controller.statoSelezionato = val;
                  });
                },
              ),

              /// Pulsante per aggiungere o modificare il libro.
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    handleControllerOperation(
                      context: context,
                      operation: () async => controller.handleAggiungiLibro(),
                      successMessage: "Libro aggiunto correttamente!",
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Aggiungi"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
