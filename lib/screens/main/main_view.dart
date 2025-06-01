/*
 * Questo file contiene l'implemenazione della struttura della schermata principale dell'applicazione, contenente lo Scaffold e la barra di navigazione in basso. Le altre schermate (homepage, libreria, statistiche) sono 
 * implementate in file separati e richiamate qui, al fine di mantenere il codice piú ordinato ed evitare di innestare scaffold.
*/

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'sub-screens/homepage_view.dart';
import 'sub-screens/libreria_view.dart';
import 'sub-screens/stats_view.dart';
import '../../components/popup_aggiunta.dart';

/// Schermata principale dell'applicazione.
/// Contiene la struttura base con uno [IndexedStack] per la navigazione tra le pagine principali
/// e una barra di navigazione inferiore curva.
/// Le schermate principali (homepage, libreria) sono gestite come tab separati.
class MainView extends StatefulWidget {
  /// Costruttore della schermata principale.
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  /// Indice della tab attualmente selezionata.
  int _selectedIndex = 0;

  /// Lista delle pagine principali mostrate nell'app.
  final List<Widget> _pages = [HomepageView(), LibreriaView(), StatisticheView()];

  /// Gestisce il cambio di tab nella barra di navigazione.
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          _selectedIndex != 2
              ? null
              : AppBar(
                title: const Text(
                  'Statistiche',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                foregroundColor: Colors.white,
                centerTitle: true,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
      body: IndexedStack(
        index:
            _selectedIndex, // mostro solo la schermata corrispondente a questo indice
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Theme.of(context).colorScheme.primary,
        index: _selectedIndex,
        onTap:
            _onTabTapped, // il parametro index (tab corrente) viene passato automaticamente,
        animationDuration: const Duration(milliseconds: 300),
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.home, size: 30, color: Colors.white),
            label: 'Home',
            labelStyle: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.library_books, size: 30, color: Colors.white),
            label: 'Libreria',
            labelStyle: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.show_chart_sharp, size: 30, color: Colors.white),
            label: 'Stats',
            labelStyle: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? EdgeInsets.only(bottom: 30.0)
                : EdgeInsets.zero,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled:
                  true, // consente al popup di occupare tutto lo schermo
              builder: (context) {
                return const PopupAggiunta();
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
