import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(spacing: 30, children: <Widget>[Header(), Body()]),
      );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 250,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF8F5CFF),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(70),
              bottomLeft: Radius.circular(150),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey,
                spreadRadius: 1,
                blurRadius: 15,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                child: Text(
                  "Welcome!",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 25),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(280, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        "Aggiungi un libro!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Stai leggendo qualcosa?",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        spacing: 30,
        children: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.blind, size: 25),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 3,
                  ),
                  label: const Text("Wishlist", style: TextStyle(fontSize: 18)),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite, size: 25),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  label: const Text(
                    "Preferiti",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              const Text(
                "Libri consigliati",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 150,
                child: CarouselView(
                  itemExtent: 200,
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8',
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8',
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8',
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              const Text(
                "Ultime aggiunte",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 150,
                child: CarouselView(
                  itemExtent: 200,
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8',
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8',
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8',
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8',
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8',
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8',
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8',
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8',
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8',
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// DA COMPLETARE
class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}