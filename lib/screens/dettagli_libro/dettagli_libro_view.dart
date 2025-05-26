import 'package:bibliotech/models/libreria.dart';
import 'package:bibliotech/models/stato_libro.dart';
import 'package:flutter/material.dart';
import '../../models/libro.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:input_quantity/input_quantity.dart';
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

  @override
  void initState() {
    super.initState();
    _tabControllerDetail = TabController(length: 2, vsync: this);

    final libroSalvato = Libreria().cercaLibroPerIsbn(widget.libro.isbn);
    if (libroSalvato == null) {
      Libreria().aggiungiLibro(widget.libro);
      libro = widget.libro;
    } else {
      libro = libroSalvato;
    }
  }

  @override
  void dispose() {
    _tabControllerDetail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dettagli libro', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.black, // Cambia colore al click
            ),
            onPressed: () {
              setState(() {
                ////gestione prefeiti
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          // Inserire codice per abilitare la modifica dei campi del libro
          
          setState(() {});
        },
        child: Icon(Icons.edit),
      ),
      
      body: Column(
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
    );
  }

  Widget bookSummary() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          Row(
            children: [
              bookImg(),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      libro.titolo,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      libro.autori?.join(', ') ?? "Autore sconosciuto",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
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
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
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

  List<Widget> buildActionButtons() {
    final stato = libro.stato;
    final haRecensione = libro.voto != null;
    List<Widget> buttons = [];

    if (stato == null) {
      // Stato nullo: mostra pulsante per iniziare a seguire il libro
      buttons.add(
        ElevatedButton(
          child: Text("Segna come 'Da leggere'"),
          onPressed: () {
            setState(() {
              libro.stato = StatoLibro.daLeggere;
            });
          },
        ),
      );
    } else {
      // Mostra stato attuale
      String statoLabel = switch (stato) {
        StatoLibro.daLeggere => "Da leggere",
        StatoLibro.inLettura => "In lettura",
        StatoLibro.letto => "Letto",
        StatoLibro.abbandonato => "Abbandonato",
        // TODO: Handle this case.
        StatoLibro.daAcquistare => throw UnimplementedError(),
      };

      buttons.add(ElevatedButton(onPressed: null, child: Text(statoLabel)));

      // Azioni aggiuntive per stato specifico
      if (stato == StatoLibro.daLeggere) {
        buttons.add(
          ElevatedButton(
            onPressed: () => mostraBottomSheetPagine(),
            child: Text("Aggiorna pagine lette"),
          ),
        );
      }

      if (stato == StatoLibro.inLettura) {
        buttons.add(
          ElevatedButton(
            onPressed: () => mostraBottomSheetPagine(),
            child: Text("Aggiorna pagine lette"),
          ),
        );

        buttons.add(
          ElevatedButton(
            onPressed: () {
              setState(() {
                libro.stato = StatoLibro.abbandonato;
              });
            },
            child: Text("Abbandona"),
          ),
        );

        if (!haRecensione) {
          buttons.add(
            ElevatedButton(
              onPressed: () => mostraBottomSheetRating(),
              child: Text("Aggiungi recensione"),
            ),
          );
        }
      }

      if ((stato == StatoLibro.letto || stato == StatoLibro.abbandonato) &&
          !haRecensione) {
        buttons.add(
          ElevatedButton(
            onPressed: () => mostraBottomSheetRating(),
            child: Text("Aggiungi recensione"),
          ),
        );
      }
    }

    return buttons;
  }

  Widget bookImg() {
    return LibroCoverWidget(libro: libro);
  }

  Widget infoSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoBlock(label: "Titolo", value: libro.titolo),
          InfoBlock(
            label: "Autore",
            value: libro.autori?.join(', ') ?? "Sconosciuto",
          ),
          InfoBlock(
            label: "Pagine",
            value: libro.numeroPagine?.toString() ?? "N/A",
          ),
          InfoBlock(label: "Genere", value: libro.genere?.toString() ?? "N/A"),
          InfoBlock(label: "ISBN", value: libro.isbn),
          InfoBlock(
            label: "Data di pubblicazione",
            value:
                libro.dataPubblicazione != null
                    ? DateFormat('yyyy-MM-dd').format(libro.dataPubblicazione!)
                    : "N/A",
          ),
          InfoBlock(label: "Produttore", value: libro.publisher ?? "N/A"),
          InfoBlock(label: "Sottotitolo", value: libro.subtitle ?? "N/A"),
          InfoBlock(label: "Lingua", value: libro.lingua ?? "N/A"),
          InfoBlock(
            label: "Trama",
            value: libro.trama ?? "Nessuna trama disponibile.",
          ),
        ],
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

  void mostraBottomSheetPagine() {
    final TextEditingController _controller_quantity = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Aggiorna pagine lette",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Pagine lette: ${libro.numPagineLette ?? 0} / ${libro.numeroPagine ?? 0}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 15),
                InputQty.int(
                  qtyFormProps: QtyFormProps(
                    controller: _controller_quantity,
                    style: TextStyle(fontSize: 25),
                  ),
                  decoration: QtyDecorationProps(
                    isBordered: false,
                    borderShape: BorderShapeBtn.circle,
                    width: 12,
                  ),

                  //fillColor: Colors.grey[200],
                  initVal: libro.numPagineLette ?? 0,
                  maxVal: libro.numeroPagine ?? 0,
                  minVal: libro.numPagineLette ?? 0,
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    final numero = _controller_quantity.text;
                    setState(() {
                      libro.numPagineLette = int.tryParse(numero);
                      Libreria().modificaLibro(libro.isbn, libro);

                      if (libro.numPagineLette! == libro.numeroPagine!) {
                        // Se tutte le pagine sono lette metto stato inlettura
                        libro.stato = StatoLibro.letto;
                        libro.numPagineLette = libro.numeroPagine;
                      } else if (libro.stato == StatoLibro.daLeggere &&
                          (libro.numPagineLette != null &&
                              libro.numPagineLette! > 0)) {
                        // Se il libro era da leggere e ora ha pagine lette, lo metto in lettura
                        libro.stato = StatoLibro.inLettura;
                      }
                      Libreria().modificaLibro(libro.isbn, libro);
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Salva"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void mostraBottomSheetRating() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Inserisci il tuo voto",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(Icons.star, color: Colors.amber),
                    onPressed: () {
                      setState(() {
                        libro.voto = index + 1.0;
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

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
