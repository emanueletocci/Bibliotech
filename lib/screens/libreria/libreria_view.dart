import 'package:flutter/material.dart';

class Libreria extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBarCustom(),
              Generi(),
              Expanded(
                child: GridView.count(
                  padding: EdgeInsets.all(3),
                  crossAxisCount: 2,
                  children: [
                    Conteinozzo(),
                    Conteinozzo(),
                    Conteinozzo(),
                    Conteinozzo(),
                    Conteinozzo(),
                    Conteinozzo(),
                    Conteinozzo(),
                    Conteinozzo(),
                    Conteinozzo(),
                    Conteinozzo(),
                    Conteinozzo(),
                    Conteinozzo(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBarCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(21)),
        hintText: 'Search Book',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}

class Conteinozzo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40, // Larghezza fissa
      height: 40, // Altezza fissa (opzionale)
      margin: EdgeInsets.all(4),
      color: Colors.red,
    );
  }
}

class Generi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(8.0)),
              Image(
                image: AssetImage('assets/images/cover1.jpg'),
                width: 60,
                height: 90,
                fit: BoxFit.cover,
              ),
              Text('Fantasy', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(8.0)),
              Image(
                image: AssetImage('assets/images/cover2.jpg'),
                width: 60,
                height: 90,
                fit: BoxFit.cover,
              ),
              Text('Science', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(8.0)),
              Image(
                image: AssetImage('assets/images/cover3.jpg'),
                width: 60,
                height: 90,
                fit: BoxFit.cover,
              ),
              Text('Leteraly', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(8.0)),
              Image(
                image: AssetImage('assets/images/cover4.jpg'),
                width: 60,
                height: 90,
                fit: BoxFit.cover,
              ),
              Text('Thriller', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
