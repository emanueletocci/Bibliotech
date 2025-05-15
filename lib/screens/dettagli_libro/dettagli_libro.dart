import 'package:flutter/material.dart';

class BookDetail extends StatefulWidget {
  const BookDetail({Key? key}) : super(key: key);

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabControllerDetail;

  @override
  void initState() {
    super.initState();
    _tabControllerDetail = TabController(
      length: 2,
      vsync: this,
    ); // Due tab: Info e Note
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
        title: Text('Dettagli Libro', style: TextStyle(color: Colors.white)),

        backgroundColor: Colors.purple,
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
      body: Column(
        children: [
          bookSummary(),

          // TAB BAR PER INFO E NOTE
          TabBar(
            controller: _tabControllerDetail,
            tabs: [Tab(text: "Info"), Tab(text: "Note")],
          ),

          // CONTENUTO DELLE SEZIONI INFO E NOTE
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

  // header devo vedere il menu humburger? forse lo elimino /////////////////////
  Widget header() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      margin: EdgeInsets.only(top: 25, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          Text(
            'Book Details',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // IMMAGINE DEL LIBRO
  Widget bookImg() {
    return Container(
      height: 200,
      width: 175,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage('assets/images/book_cover.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  // SEZIONE RIASSUNTO DEL LIBRO
  Widget bookSummary() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          bookImg(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book Title',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Author Name',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 10),
                Text('RECENSIONE: ⭐⭐⭐⭐', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SEZIONE INFO
  Widget infoSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoBlock(label: "Titolo", value: "Il Signore degli Anelli"),
          InfoBlock(label: "Autore", value: "J.R.R. Tolkien"),
          InfoBlock(label: "Pagine", value: "1216"),
          InfoBlock(label: "Tipo", value: "Fantasy"),
          InfoBlock(label: "ISBN", value: "978-88-452-9646-4"),
          InfoBlock(label: "Stato", value: "Disponibile"),
          InfoBlock(label: "Lingua", value: "Italiano"),
          InfoBlock(
            label: "Trama",
            value: "Un epico viaggio nella Terra di Mezzo...",
          ),
        ],
      ),
    );
  }

  // SEZIONE NOTE/RECENSIONI
  Widget noteSection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListView(
        children: [
          Text(
            "Recensione 1: Fantastico per imparare Flutter!",
            style: TextStyle(fontSize: 16),
          ),
          Divider(),
          Text("Recensione 2: Ben scritto e chiaro."),
          Divider(),
          Text("Recensione 3: Molto utile per progetti reali."),
        ],
      ),
    );
  }

  // FUNZIONE PER CREARE OGNI RIGA DI INFO
}

class InfoBlock extends StatelessWidget {
  final String label;
  final String value;

  const InfoBlock({Key? key, required this.label, required this.value})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
        ),
      ),
    );
  }
}
