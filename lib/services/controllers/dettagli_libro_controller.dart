import 'package:bibliotech/models/stato_libro.dart';
import 'package:flutter/material.dart';
import '../../models/genere_libro.dart';
import '../../models/libro.dart';

class DettagliLibroController {
  final List<GenereLibro> generi = GenereLibro.values.toList();
  final List<StatoLibro> stati = StatoLibro.values.toList();

  final TextEditingController titoloController = TextEditingController();
  final TextEditingController autoriController = TextEditingController();
  final TextEditingController numeroPagineController = TextEditingController();
  final TextEditingController linguaController = TextEditingController();
  final TextEditingController tramaController = TextEditingController();
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController dataPubblicazioneController =
      TextEditingController();
  final TextEditingController votoController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  GenereLibro? genereSelezionato;
  StatoLibro? statoSelezionato;

  DettagliLibroController(Libro libro) {
    titoloController.text = libro.titolo;

  }


  void aggiornaLibro(Libro libro) {
    libro.titolo = titoloController.text;
    // ... aggiorna gli altri campi
  }
}
