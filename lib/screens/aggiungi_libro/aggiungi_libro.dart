import 'package:flutter/material.dart';
 
class AggiungiLibro extends StatefulWidget {
  final String immLibro;

  const AggiungiLibro({super.key, required this.immLibro});

  @override
  State<AggiungiLibro> createState() => _AggiungiLibroState();
}

class _AggiungiLibroState extends State<AggiungiLibro> {
  final TextEditingController titoloController = TextEditingController();
  final TextEditingController autoriController = TextEditingController();
  final TextEditingController linguaController = TextEditingController();
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController dataPubblicazioneController =
      TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final List<String> categorie = ['Science', 'Thriller', 'Fantasy'];
  String? categoriaSelezionata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aggiungi un nuovo libro!"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  "https://covers.openlibrary.org/b/isbn/9780385533225-L.jpg",
                  height: 200,
                  width: 140,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            TextField(
              controller: titoloController,
              decoration: const InputDecoration(labelText: 'Titolo*'),
            ),
            TextField(
              controller: autoriController,
              decoration: const InputDecoration(labelText: 'Autori'),
            ),
            TextField(
              controller: autoriController,
              decoration: const InputDecoration(labelText: 'Numero Pagine'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Categoria'),
              items:
                  categorie.map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),
              onChanged: (val) {
                setState(() { // Added setState here
                  categoriaSelezionata = val;
                });
              },
            ),
            TextField(
              controller: linguaController,
              decoration: const InputDecoration(labelText: 'Lingua'),
            ),
            TextField(
              controller: isbnController,
              decoration: const InputDecoration(labelText: 'Trama'),
            ),
            TextField(
              controller: isbnController,
              decoration: const InputDecoration(labelText: 'ISBN*'),
            ),
            TextField(
              controller: dataPubblicazioneController,
              decoration: const InputDecoration(
                labelText: 'Data Pubblicazione',
              ),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: isbnController,
              decoration: const InputDecoration(labelText: 'Voto'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Note personali'),
            ),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  //String titolo = titoloController.text;
                },
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
    );
  }
    @override
  void dispose() {
    titoloController.dispose();
    autoriController.dispose();
    linguaController.dispose();
    isbnController.dispose();
    dataPubblicazioneController.dispose();
    noteController.dispose();
    super.dispose();
  }
}

