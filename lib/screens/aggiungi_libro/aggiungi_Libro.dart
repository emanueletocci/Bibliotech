import 'package:flutter/material.dart';

class AggiungiLibro extends StatelessWidget {
  final String immLibro;

  AggiungiLibro({super.key, required this.immLibro});

  final TextEditingController titoloController = TextEditingController();
  final TextEditingController autoriController = TextEditingController();
  final TextEditingController linguaController = TextEditingController();
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController dataPubblicazioneController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final List<String> categorie = ['Science', 'Thriller', 'Fantasy'];
  String? categoriaSelezionata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Aggiungi libro")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  immLibro,
                  height: 200,
                  width: 140,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: titoloController,
              decoration: const InputDecoration(labelText: 'Titolo del libro'),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: autoriController,
              decoration: const InputDecoration(labelText: 'Autori'),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: linguaController,
              decoration: const InputDecoration(labelText: 'Lingua'),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: isbnController,
              decoration: const InputDecoration(labelText: 'ISBN'),
            ),
            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Categoria'),
              items: categorie.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (val) {
                categoriaSelezionata = val;
              },
            ),
            const SizedBox(height: 10),

            TextField(
              controller: dataPubblicazioneController,
              decoration: const InputDecoration(labelText: 'Data Pubblicazione'),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 10),

            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Note personali'),
            ),
            const SizedBox(height: 20),
             Center(
              child: ElevatedButton.icon(
                onPressed: () {
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
}