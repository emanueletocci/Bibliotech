import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

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
                  padding: EdgeInsets.all(7),
                  crossAxisCount: 2,
                  children: [
                    Libro(path: 'assets/images/book2.jpg'),
                    Libro(path: 'assets/images/book3.jpg'),
                    Libro(path: 'assets/images/book4.jpg'),
                    Libro(path: 'assets/images/book5.jpg'),
                    Libro(path: 'assets/images/book6.jpg'),
                    Libro(path: 'assets/images/book1.jpg'),
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

class Libro extends StatelessWidget {
  final String path;
  const Libro({Key? key, required this.path}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {print("prova in debug console")},
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.all(4),
        child: Image(image: AssetImage(path)),
      ),
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
              Text('Thriller', style: TextStyle(fontWeight: FontWeight.bold)),
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
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(8.0)),
              Image(
                image: AssetImage('assets/images/cover4.jpg'),
                width: 60,
                height: 90,
                fit: BoxFit.cover,
              ),
              Text('Science', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
