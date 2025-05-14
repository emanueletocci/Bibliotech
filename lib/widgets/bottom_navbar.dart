import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {

  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categorie'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Statistiche'),
      ],
    );
  }
}
