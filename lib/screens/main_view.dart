/*
 * Questo file contiene l'implemenazione della struttura della schermata principale dell'applicazione, contenente lo Scaffold e la barra di navigazione in basso. Le altre schermate (homepage, libreria, statistiche) sono 
 * implementate in file separati e richiamate qui, al fine di mantenere il codice piú ordinato ed evitare di innestare scaffold.
*/

import 'package:flutter/material.dart';
import 'home/homepage_view.dart';
import 'libreria/libreria_view.dart';
import '../components/popup_aggiunta.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(title: "Homepage"),
    Libreria(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,  // mostro solo la schermata corrispondente a questo indice
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped, // il parametro index (tab corrente) viene passato automaticamente,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Libreria',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistiche',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,  // consente al popup di occupare tutto lo schermo
            builder: (context) {
              return const PopupAggiunta();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}