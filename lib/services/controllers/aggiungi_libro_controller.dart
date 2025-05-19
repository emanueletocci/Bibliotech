// Implementazione del controller per la pagina di aggiunta libro
// Da decidere se implementare un controller differente per l'aggiunta tramite API e quella tramite barcode (se decidiamo di lasciarla)

import 'package:flutter/material.dart';

class AggiungiLibroController {
  final TextEditingController titoloController = TextEditingController();
  final TextEditingController autoriController = TextEditingController();
  final TextEditingController numeroPagineController = TextEditingController();
  final TextEditingController linguaController = TextEditingController();
  final TextEditingController tramaController = TextEditingController();
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController dataPubblicazioneController = TextEditingController();
  final TextEditingController votoController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController statoController = TextEditingController();

  String? categoriaSelezionata;
  String? statoSelezionato;
}
