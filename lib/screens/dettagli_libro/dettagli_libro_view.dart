import 'package:bibliotech/models/libreria.dart';
import 'package:bibliotech/models/stato_libro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/libro.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating/flutter_rating.dart';
import '../../components/libro_cover_widget.dart';

class BookDetail extends StatefulWidget {
  final Libro libro;

  const BookDetail({super.key, required this.libro});

  @override
  State<BookDetail> createState() => _BookDetailState();
}

// Il mixin SingleTickerProviderStateMixin permette alla classe _BookDetailState di gestire una singola animazione (in questo caso, la navigazione tra le tab)
// in modo efficiente e sicuro, evitando che l’animazione continui anche quando la pagina non è più visibile.
// In pratica, il mixin fornisce il parametro vsync: this che viene passato al TabController:

class _BookDetailState extends State<BookDetail>
    with SingleTickerProviderStateMixin {
  // Controller per le tab del dettaglio libro
  late TabController _tabControllerDetail;
  late Libro libro;
  late Libreria? libreria;
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    _tabControllerDetail = TabController(
      length: 2, // Due tab: Info e Note
      vsync: this, // Fornisce il parametro vsync per l'animazione
    );
    // Uso una copia locale del libro passato dal widget per eventuali modifiche da parte dell'utente
    libro = widget.libro;

    // Inizializzo lo stato dei toggle buttons
    isFavorite = false;
  }

  // didChangeDependencies viene chiamato quando le dipendenze del widget cambiano (eg. mediaQuery, Theme...)
  // viene eseguito subito dopo initState e prima di build
  // In questo modo la libreria e il controller non vengono ricreati ad ogni build e mantengo lo stato condiviso

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    libreria = context.watch<Libreria>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dettagli libro', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Inserire codice per abilitare la modifica dei campi del libro
          setState(() {});
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
                      libro.autori?.join(', ') ?? "Autore sconosciuto",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    // Mostro le stelle della valutazione solo se il libro ha un voto
                    if (libro.voto != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: StarRating(
                          size: 22.0,
                          starCount: 5,
                          rating: libro.voto!,
                          onRatingChanged: (rating) {}, // rating fisso
                        ),
                      ),
                    // Toggle Buttons per preferiti
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
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
            spacing: 10, // spazio tra i figli sulla stessa riga
            runSpacing: 10, // spazio tra le righe
            alignment: WrapAlignment.center,
            children: buildActionButtons(),
          ),
        ],
      ),
    );
  }

  ///posso fare percentuale lettura per ogni libro nella libreria
  //totali libri letti, abbandonati e inlettura e da incominciare
  ///e mostrare un grafico a torta con le percentuali
  ///statistiche recensioni... //mostro pulsanti diversi a seconda dello stato del libro:
  // - Se il libro non é presente in Libreria, mostro "Aggiungi alla biblioteca"
  // - Se il libro è "In lettura", mostro "Aggiorna pagine lette", "Abbandona" e "Aggiungi recensione"
  // - Se il libro è "Letto" o "Abbandonato", mostro "Aggiungi recensione"
  // I pulsanti preferiti e wishlist (da acquistare) li lascio sempre visibili come toggle

  List<Widget> buildActionButtons() {
    final stato = libro.stato;
    final haRecensione = libro.voto != null;
    final isInLibreria = libreria?.cercaLibroPerIsbn(libro.isbn) != null;
    List<Widget> buttons = [];

    // Se il libro non è presente nella libreria, aggiungo solo il pulsante per aggiungerlo
    if (!isInLibreria) {
      buttons.add(
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
          label: Text("Aggiungi alla libreria"),
          icon: Icon(Icons.add_circle_outline, color: Colors.white),
          onPressed: () {
            libreria?.aggiungiLibro(libro);
          },
        ),
      );
    } else {
      buttons.add(
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
          label: Text("Rimuovi dalla libreria"),
          icon: Icon(Icons.remove, color: Colors.white),
          onPressed: () {
            libreria?.rimuoviLibro(libro);
          },
        ),
      );
      // Gestione dei pulsanti in base allo stato del libro (solo se il libro è in libreria)
      switch (stato) {
        case StatoLibro.daLeggere:
          buttons.add(
            ElevatedButton(
              onPressed: () => (),
              child: Text("Inizia la lettura"),
            ),
          );
          break;
        case StatoLibro.inLettura:
          buttons.add(
            ElevatedButton(
              onPressed: () {
                setState(() {
                  libro.stato = StatoLibro.abbandonato;
                });
              },
              child: Text("Abbandona lettura"),
            ),
          );
          if (!haRecensione) {
            buttons.add(
              ElevatedButton(
                onPressed: () => (),
                child: Text("Aggiungi recensione"),
              ),
            );
          }
          break;
        case StatoLibro.abbandonato:
          buttons.add(
            ElevatedButton(
              onPressed: () {
                setState(() {
                  libro.stato = StatoLibro.inLettura;
                });
              },
              child: Text("Riprendi lettura"),
            ),
          );
          if (!haRecensione) {
            buttons.add(
              ElevatedButton(
                onPressed: () => (),
                child: Text("Aggiungi recensione"),
              ),
            );
          }
          break;
        default:
          break;
      }
    }
    return buttons;
  }

  Widget bookImg() {
    return SizedBox(
      width: 175,
      height: 225,
      child: LibroCoverWidget(libro: libro),
    );
  }

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

  Widget noteSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            libro.note ?? "Nessuna nota disponibile.",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Metodo helper per costruire i blocchi di informazioni relativi al libro, basato sui campi disponibili
  // Se un campo del model é null, non mostro nulla
  List<Widget> buildInfoBlocks(Libro libro) {
    return [
      // Titolo (sempre presente)
      InfoBlock(label: "Titolo", value: libro.titolo),

      // Autori (solo se presenti)
      if (libro.autori != null && libro.autori!.isNotEmpty)
        InfoBlock(label: "Autore", value: libro.autori!.join(', ')),

      // Pagine (solo se presente)
      if (libro.numeroPagine != null)
        InfoBlock(label: "Pagine", value: libro.numeroPagine!.toString()),

      // Genere (solo se presente)
      if (libro.genere != null)
        InfoBlock(label: "Genere", value: libro.genere!.toString()),

      // ISBN (sempre presente?)
      InfoBlock(label: "ISBN", value: libro.isbn),

      // Data di pubblicazione (solo se presente)
      if (libro.dataPubblicazione != null)
        InfoBlock(
          label: "Data di pubblicazione",
          value: DateFormat('yyyy-MM-dd').format(libro.dataPubblicazione!),
        ),

      // Produttore (solo se presente)
      if (libro.publisher != null)
        InfoBlock(label: "Produttore", value: libro.publisher!),

      // Lingua (solo se presente)
      if (libro.lingua != null)
        InfoBlock(label: "Lingua", value: libro.lingua!),

      // Trama (solo se presente)
      if (libro.trama != null && libro.trama!.isNotEmpty)
        InfoBlock(label: "Trama", value: libro.trama!),

      // Note (solo se presente)
      if (libro.note != null && libro.note!.isNotEmpty)
        InfoBlock(label: "Note", value: libro.note!),

      // Stato (solo se presente)
      if (libro.stato != null)
        InfoBlock(label: "Stato", value: libro.stato!.titolo),

      // Voto (solo se presente)
      if (libro.voto != null)
        InfoBlock(label: "Voto", value: libro.voto!.toString()),
    ];
  }
}

// Widget per mostrare un blocco di informazioni con etichetta e valore
class InfoBlock extends StatelessWidget {
  final String label;
  final String value;

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
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, color: Colors.black)),
        ],
      ),
    );
  }
}
