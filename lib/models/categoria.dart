import 'package:flutter/material.dart';

class Categoria {
  final String nome;
  final IconData? icona;
  final Color? colore;

  Categoria({
    required this.nome,
    this.icona,
    this.colore,
  });
}
