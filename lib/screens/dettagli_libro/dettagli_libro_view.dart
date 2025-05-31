import 'package:bibliotech/components/feedback.dart';
import 'package:bibliotech/models/libreria_model.dart';
import 'package:bibliotech/screens/aggiungi_libro/aggiunta_modifica_manuale_view.dart';
import 'package:bibliotech/services/controllers/aggiunta/dettagli_libro_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/libro_model.dart';
import 'package:flutter_rating/flutter_rating.dart';
import '../../components/libro_cover_widget.dart';

/// Schermata che mostra i dettagli di un libro.
/// Permette di visualizzare informazioni, note, modificare o rimuovere il libro dalla libreria.
/// Consente anche di aggiungere il libro se non presente.
class DettagliLibroView extends StatefulWidget {
  /// Il libro di cui mostrare i dettagli.
  final Libro libro;

  /// Costruttore della schermata dettagli libro.
  const DettagliLibroView({super.key, required this.libro});

  @override
  State<DettagliLibroView> createState() => _DettagliLibroViewState();
}

/// Stato della schermata dettagli libro.
/// Gestisce la visualizzazione, modifica e azioni sul libro.
/// Usa [SingleTickerProviderStateMixin] per gestire le tab animate.
class _DettagliLibroViewState extends State<DettagliLibroView>
    with SingleTickerProviderStateMixin {
  /// Controller per le tab del dettaglio libro.
  late TabController _tabControllerDetail;

  /// Istanza locale del libro visualizzato.
  late Libro libro;

  /// Riferimento alla libreria dell'utente.
  late Libreria libreria;

  /// Controller per la logica di dettaglio libro.
  late DettagliLibroController controller;

  /// Indica se la modalità di modifica è attiva.
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _tabControllerDetail = TabController(
      length: 2, // Due tab: Info e Note
      vsync: this,
    );
    libro = widget.libro;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    libreria = context.watch<Libreria>();
    controller = DettagliLibroController(libreria, libro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dettagli libro'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isEditing = !isEditing;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AggiuntaModificaLibroManualeView(
                    libroDaModificare: libro,
                  ),
            ),
          );
        },
        child: Icon(Icons.edit),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bookSummary(),
            TabBar(
              controller: _tabControllerDetail,
              tabs: [Tab(text: "Info"), Tab(text: "Note")],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabControllerDetail,
                children: [infoSection(), noteSection()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Mostra la copertina e i dettagli principali del libro.
  Widget bookSummary() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        spacing: 15,
        children: [
          Row(
            spacing: 15,
            children: [
              bookImg(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      libro.titolo,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      libro.getAutoriString(),
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    if (libro.voto != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: StarRating(
                          size: 22.0,
                          allowHalfRating: true,
                          starCount: 5,
                          // gestisce automaticamente la normalizzaazione del voto per i fuori-range: eg. 15 = 5,
                          rating: libro.voto!,  
                          onRatingChanged: (_) {},
                        ),
                      ),
                    IconButton(
                      icon: Icon(
                        libro.preferito
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: libro.preferito ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        // void
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: buildActionButtons(),
          ),
        ],
      ),
    );
  }

  /// Costruisce i pulsanti di azione in base allo stato del libro e alla presenza in libreria.
  List<Widget> buildActionButtons() {
    final isInLibreria = libreria.cercaLibroPerIsbn(libro.isbn) != null;
    List<Widget> buttons = [];

    if (!isInLibreria) {
      buttons.add(
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          label: Text("Aggiungi alla libreria"),
          icon: Icon(Icons.add_circle_outline),
          onPressed: () {
            handleControllerOperation(
              context: context,
              operation: () async => controller.handleAggiungiLibro(),
              successMessage: "Libro aggiunto correttamente!",
            );
          },
        ),
      );
    } else {
      buttons.add(
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Colors.white,
          ),
          label: Text("Rimuovi dalla libreria"),
          icon: Icon(Icons.remove),
          onPressed: () async {
            handleControllerOperation(
              context: context,
              operation: () async => controller.handleRimuoviLibro(),
              successMessage: "Libro rimosso correttamente!",
            );
          },
        ),
      );
    }
    return buttons;
  }

  /// Mostra la copertina del libro.
  Widget bookImg() {
    return SizedBox(
      width: 175,
      height: 225,
      child: LibroCoverWidget(libro: libro),
    );
  }

  /// Sezione con le informazioni dettagliate del libro.
  Widget infoSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        spacing: 3,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildInfoBlocks(libro),
      ),
    );
  }

  /// Sezione con le note del libro.
  Widget noteSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(libro.getNoteString(), style: TextStyle(fontSize: 16))],
      ),
    );
  }

  /// Costruisce i blocchi di informazioni relativi al libro.
  List<Widget> buildInfoBlocks(Libro libro) {
    return [
      InfoBlock(label: "Titolo", value: libro.titolo),
      InfoBlock(label: "Autori", value: libro.getAutoriString()),
      if (libro.numeroPagine != null)
        InfoBlock(label: "Pagine", value: libro.numeroPagine!.toString()),
      if (libro.genere != null)
        InfoBlock(label: "Genere", value: libro.genere!.toString()),
      InfoBlock(label: "ISBN", value: libro.isbn),
      if (libro.dataPubblicazione != null)
        InfoBlock(
          label: "Data di pubblicazione",
          value: DateFormat('dd/MM/yyyy').format(libro.dataPubblicazione!),
        ),
      if (libro.publisher != null)
        InfoBlock(label: "Produttore", value: libro.publisher!),
      if (libro.lingua != null && libro.lingua!.isNotEmpty)
        InfoBlock(label: "Lingua", value: libro.lingua!),
      if (libro.note != null && libro.note!.isNotEmpty)
        InfoBlock(label: "Note", value: libro.note!),
      if (libro.stato != null)
        InfoBlock(label: "Stato", value: libro.stato!.titolo),
      if (libro.voto != null)
        InfoBlock(label: "Voto", value: libro.voto!.toStringAsFixed(1)),    // formatto ad una cifra decimale
      if (libro.trama != null && libro.trama!.isNotEmpty)
        InfoBlock(label: "Trama", value: libro.trama!),

    ];
  }
}

/// Widget per mostrare un blocco di informazioni con etichetta e valore.
class InfoBlock extends StatelessWidget {
  /// Etichetta del campo.
  final String label;

  /// Valore del campo.
  final String value;

  /// Costruttore del blocco informativo.
  const InfoBlock({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
