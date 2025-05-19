import 'package:flutter/material.dart';

class Libreria extends StatefulWidget {
  const Libreria({super.key});

  @override
  State<Libreria> createState() => _LibreriaState();
}
class _LibreriaState extends State<Libreria> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Libreria"),
      ],
    );
  }
}