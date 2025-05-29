import 'package:bibliotech/models/stato_libro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/libro_cover_widget.dart';
import '../../components/feedback.dart';
import '../../models/genere_libro.dart';
import '../../models/libro.dart';
import '../../services/controllers/aggiunta/aggiunta_modifica_manuale_controller.dart';
import '../../models/libreria.dart';

class AggiuntaModificaLibroManualeView extends StatefulWidget {
  final Libro? libroDaModificare;

  const AggiuntaModificaLibroManualeView({super.key, this.libroDaModificare});

  @override
  State<AggiuntaModificaLibroManualeView> createState() =>
      _AggiuntaModificaLibroManualeViewState();
}

class _AggiuntaModificaLibroManualeViewState
    extends State<AggiuntaModificaLibroManualeView> {
  late AggiuntaModificaManualeController controller;
  bool _isControllerInitialized = false;
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = false; // Inizializzo lo stato del preferito a false
  }

  @override
  Widget build(BuildContext context) {
    if (!_isControllerInitialized) {
      final libreria = context.watch<Libreria>();
      controller = AggiuntaModificaManualeController(
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
                      // Creo un'istanza temporanea del libro... mi interessa solo la copertina
                      libro: Libro(
                        isbn: controller.isbnController.text,
                        copertina: controller.copertina,
                        titolo: '',
                      ),
                    ),
                  ),
                ),
              ),
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
              TextField(
                controller: controller.titoloController,
                decoration: const InputDecoration(labelText: 'Titolo*'),
              ),
              TextField(
                controller: controller.autoriController,
                decoration: const InputDecoration(labelText: 'Autori'),
              ),
              TextField(
                controller: controller.numeroPagineController,
                decoration: const InputDecoration(labelText: 'Numero Pagine'),
                keyboardType: TextInputType.number,
              ),
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

              TextField(
                controller: controller.linguaController,
                decoration: const InputDecoration(labelText: 'Lingua'),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: controller.tramaController,
                decoration: const InputDecoration(labelText: 'Trama'),
              ),
              TextField(
                controller: controller.isbnController,
                decoration: const InputDecoration(labelText: 'ISBN*'),
              ),
              TextField(
                controller: controller.dataPubblicazioneController,
                decoration: const InputDecoration(
                  labelText: 'Data Pubblicazione',
                ),
                keyboardType: TextInputType.datetime,
              ),
              TextField(
                controller: controller.votoController,
                decoration: const InputDecoration(labelText: 'Voto'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: controller.noteController,
                decoration: const InputDecoration(labelText: 'Note personali'),
              ),
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
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await handleControllerOperation(
                      context: context,
                      operation: () async => controller.handleAggiungiLibro(),
                      successMessage: "Libro rimosso correttamente!",
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
