import 'package:flutter/material.dart';
import '../../services/controllers/aggiungi_libro_controller.dart';
import '../main_view.dart';
import 'dart:io';

class AggiungiLibro extends StatefulWidget {
  const AggiungiLibro({super.key});

  @override
  State<AggiungiLibro> createState() => _AggiungiLibroState();
}

class _AggiungiLibroState extends State<AggiungiLibro> {
  final AggiungiLibroController controller = AggiungiLibroController();

  void _handleAggiungiLibro() {
    try {
      controller.handleAggiungi(); // Chiama il metodo per aggiungere il libro
      // Se handleAggiungi() viene eseguito senza errori, mostro uno SnackBar
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

        Navigator.of(context).push(
          // Usare pushReplacement per evitare di tornare alla pagina di aggiunta
          MaterialPageRoute(builder: (context) => const MainScreen()),
        ); // torno alla schermata principale se non vengono lanciate eccezioni

      });
    } catch (e) {
      String errorMessage = e.toString();
      const prefix = 'Exception: ';
      if (errorMessage.startsWith(prefix)) {
        // Rimuovo il prefisso "Exception: " dal messaggio di errore
        errorMessage = errorMessage.substring(prefix.length);
      }
      // Se viene lanciata un'eccezione, mostro un messaggio di errore
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
    setState(() {});    // Aggiorno lo stato per riflettere eventuali modifiche sull'UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aggiungi un nuovo libro!"),
        backgroundColor: Colors.deepPurple,
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
                  onTap: () async{
                    await controller.selezionaCopertina();
                    setState(() {
                      // Aggiorna lo stato per mostrare l'immagine selezionata
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 200,
                      width: 140,
                      child: Builder(
                        builder: (context) {
                          // Mostra l'immagine se disponibile, altrimenti un placeholder
                          if ((controller.copertina.startsWith('http://')) ||
                              (controller.copertina.startsWith('https://'))) {
                            // È un URL remoto! Mostra l'immagine remota
                            return Image.network(
                              controller.copertina,
                              fit: BoxFit.cover,
                            );
                          // Non si puó usare Image.file con gli elementi presenti in assets per cui
                          // devo controllare manualmente se l'immagine è il placeholder di default
                          } else if (controller.copertina == 'assets/images/book_placeholder.jpg'){
                            // Mostra il placeholder di default
                            return Image.asset(
                              controller.copertina,
                              fit: BoxFit.cover,
                            );
                          }
                          else {
                            // È un percorso locale! Crea un oggetto File e mostra l'immagine locale
                            final File localImageFile = File(
                              controller.copertina,
                            );
                            return Image.file(
                              localImageFile,
                              fit: BoxFit.cover,
                            );
                          }
                        },
                      ),
                    ),
                  ),
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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Categoria'),
                value: controller.genereSelezionato,
                items:
                    controller.generi
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Stato'),
                value: controller.statoSelezionato,
                items:
                    controller.stati
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
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
                  onPressed:
                      _handleAggiungiLibro, 
                  icon: const Icon(Icons.add),
                  label: const Text("Aggiungi"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade100,
                    foregroundColor: Colors.deepPurple.shade800,
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
