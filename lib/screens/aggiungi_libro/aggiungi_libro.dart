import 'package:flutter/material.dart';

class AggiungiLibro extends StatefulWidget {
  final String immLibro;

  const AggiungiLibro({super.key, required this.immLibro});

  @override
  State<AggiungiLibro> createState() => _AggiungiLibroState();
}

class _AggiungiLibroState extends State<AggiungiLibro> {
  final titolo = TextField();
  final autori = TextField();
  final lingua = TextField();
  final isbn = TextField();
  final dataPubblicazione = TextField();
  final note = TextField();

  final List<String> categorie = ['Science', 'Thriller', 'Fantasy'];
  String? categoriaSelezionata;

  @override
  Widget build(BuildContext context) {
    final String? immDaMostrare =
        widget.immLibro.isEmpty ? null : widget.immLibro;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Aggiungi libro"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child:
                  widget.immLibro.isEmpty
                      ? Container(
                        height: 200,
                        width: 160,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.add,
                            size: 40,
                            color: Colors.deepPurple,
                          ),
                        ),
                      )
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.immLibro,
                          height: 200,
                          width: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              width: 140,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.deepPurple,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  size: 30,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: 'Titolo del libro'),
            ),

            const SizedBox(height: 10),
            TextField(decoration: const InputDecoration(labelText: 'Autori')),

            const SizedBox(height: 10),
            TextField(decoration: const InputDecoration(labelText: 'Lingua')),

            const SizedBox(height: 10),
            TextField(decoration: const InputDecoration(labelText: 'ISBN')),

            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Categoria'),
              items:
                  categorie.map((genere) {
                    return DropdownMenuItem(value: genere, child: Text(genere));
                  }).toList(),
              onChanged: (val) {
                categoriaSelezionata = val;
              },
            ),

            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Data Pubblicazione',
              ),
              keyboardType: TextInputType.datetime,
            ),

            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: 'Note personali'),
            ),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
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
