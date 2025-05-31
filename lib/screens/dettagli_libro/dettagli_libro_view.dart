import 'package:bibliotech/components/feedback.dart';
import 'package:bibliotech/models/libreria_model.dart';
import 'package:bibliotech/models/stato_libro_model.dart';
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
  /// Il libro di cui mostrare i dettagli
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
  // Controller per le tab del dettaglio libro
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
      vsync: this, // Fornisce il parametro vsync per l'animazione
    );
    libro = widget.libro;
    controller = DettagliLibroController(Libreria(), libro);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    libreria = context.watch<Libreria>();
    //controller = DettagliLibroController(libreria, libro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dettagli libro'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              libro.preferito ? Icons.favorite : Icons.favorite_border,
            ), // Icona del cuore (vuota)
            onPressed: () async {
              final nuovoLibro = libro.copyWith(preferito: !libro.preferito);
              await libreria.modificaLibro(libro, nuovoLibro);
              setState(() => libro = nuovoLibro);
            },
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isEditing = !isEditing; // toggle della modalità di modifica
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

            // Tab bar per info e note
            TabBar(
              controller: _tabControllerDetail,
              tabs: [Tab(text: "Info"), Tab(text: "Note")],
            ),

            // Contenuto info e note
            Expanded(
              // Espande il TabBarView per occupare lo spazio rimanente, inoltre solo i tab sono scrollabili
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

  // Copertina + dettagli in grassetto
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
                      maxLines: 2, // Mostra al massimo 2 righe
                      overflow:
                          TextOverflow
                              .ellipsis, // Mostro "..." se il testo è troppo lungo
                    ),
                    Text(
                      libro.getAutoriString(),
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    // Mostro le recensioni solo se il libro ne ha uno. Permetto di dare una recensione solo se l'utente
                    //ha letto il libro,
                    //sta leggendo il libro
                    //ha abbandonato la lettura
                    Align(
                      alignment: Alignment.centerLeft,
                      child:
                          (libro.stato == StatoLibro.inLettura ||
                                  libro.stato == StatoLibro.abbandonato ||
                                  libro.stato == StatoLibro.letto)
                              ? StarRating(
                                size: 22.0,
                                starCount: 5,
                                rating: libro.voto?.toDouble() ?? 0.0,
                                onRatingChanged:
                                    libro.voto == null
                                        ? (rating) async {
                                          final nuovoLibro = libro.copyWith(
                                            voto: rating,
                                          );
                                          await libreria.modificaLibro(
                                            libro,
                                            nuovoLibro,
                                          );
                                          setState(() => libro = nuovoLibro);
                                        }
                                        : null,
                              )
                              : Container(),
                    ),

                    if (libro.stato != null)
                      Container(
                        margin: EdgeInsets.only(top: 2),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Text(
                          libro.stato!.titolo,
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          // Wrap é un layout widget che permette di disporre i figli in righe e colonne,
          // permettendo di andare a capo quando non c'è spazio sufficiente...
          // Gestisce automaticamente l'overflow
          Wrap(
            spacing: 5, // spazio tra i figli sulla stessa riga
            runSpacing: 5, // spazio tra le righe
            alignment: WrapAlignment.center,
            children: buildActionButtons(),
          ),
        ],
      ),
    );
  } // - Se il libro non é presente in Libreria, mostro "Aggiungi alla biblioteca"

  // - Se il libro è "In lettura", mostro "Aggiorna pagine lette", "Abbandona" e "Aggiungi recensione"
  // - Se il libro è "Letto" o "Abbandonato", mostro "Aggiungi recensione"
  // I pulsanti preferiti e wishlist (da acquistare) li lascio sempre visibili come toggle
  List<Widget> buildActionButtons() {
    final stato = libro.stato;

    final isInLibreria = libreria.cercaLibroPerIsbn(libro.isbn) != null;
    List<Widget> buttons = [];

    // Se il libro non è presente nella libreria, aggiungo solo il pulsante per aggiungerlo
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
          icon: Icon(Icons.remove),
          label: Text("Rimuovi"),
          onPressed: () async {
            handleControllerOperation(
              context: context,
              operation: () async => controller.handleRimuoviLibro(),
              successMessage: "Libro rimosso correttamente!",
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Colors.white,
          ),
        ),
      );

      // Gestione dei pulsanti in base allo stato del libro (solo se il libro è in libreria)
      switch (stato) {
        case StatoLibro.inLettura:
          buttons.add(
            ElevatedButton(
              onPressed: () async {
                final nuovoLibro = libro.copyWith(
                  stato: StatoLibro.abbandonato,
                );
                await libreria.modificaLibro(libro, nuovoLibro);
                setState(() => libro = nuovoLibro);
              },

              child: Text("Abbandona lettura"),
            ),
          );
          break;

        case StatoLibro.abbandonato:
          buttons.add(
            ElevatedButton(
              onPressed: () async {
                final nuovoLibro = libro.copyWith(stato: StatoLibro.inLettura);
                await libreria.modificaLibro(libro, nuovoLibro);
                setState(() => libro = nuovoLibro);
              },

              child: Text("Riprendi lettura"),
            ),
          );
          break;

        default:
          break;
      }
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
    // Se la modalitá di modifica é attiva, mostro i campi modificabili (tutti quelli del model Libro)
    return [
      InfoBlock(label: "Titolo", value: libro.titolo),

      // Qui la gestione degli autori é delegata al metodo getAutoriString() del model Libro
      InfoBlock(label: "Autori", value: libro.getAutoriString()),
      if (libro.numeroPagine != null)
        InfoBlock(label: "Pagine", value: libro.numeroPagine!.toString()),

      if (libro.genere != null)
        InfoBlock(label: "Genere", value: libro.genere!.toString()),

      InfoBlock(label: "ISBN", value: libro.isbn),

      if (libro.dataPubblicazione != null)
        InfoBlock(
          label: "Data di pubblicazione",
          value: DateFormat('yyyy-MM-dd').format(libro.dataPubblicazione!),
        ),

      if (libro.publisher != null)
        InfoBlock(label: "Produttore", value: libro.publisher!),

      if (libro.lingua != null && libro.lingua!.isNotEmpty)
        InfoBlock(label: "Lingua", value: libro.lingua!),
      if (libro.trama != null && libro.trama!.isNotEmpty)
        InfoBlock(label: "Trama", value: libro.trama!),

      if (libro.stato != null)
        InfoBlock(label: "Stato", value: libro.stato!.titolo),
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
