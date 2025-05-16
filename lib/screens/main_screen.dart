/*
 * Questo file contiene l'implemenazione della struttura della schermata principale dell'applicazione, contenente lo Scaffold e la barra di navigazione in basso. Le altre schermate (homepage, libreria, statistiche) sono 
 * implementate in file separati e richiamate qui, al fine di mantenere il codice piú ordinato ed evitare di innestare scaffold.
*/

import 'package:flutter/material.dart';
import 'home/homepage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(title: "Homepage"),
    //BooksPage(),
    //ProfilePage(),
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
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
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
          // Azione del pulsante floating
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
