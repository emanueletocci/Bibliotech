//https://docs.flutter.dev/cookbook/persistence/sqlite
//documentazione utile
import 'dart:async';

import 'package:bibliotech/models/genere_libro.dart';
import 'package:bibliotech/models/libro.dart';
import 'package:bibliotech/models/stato_libro.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Database globale, pronto per essere usato ovunque
final Future<Database> libri =
    (() async {
      WidgetsFlutterBinding.ensureInitialized();
      return openDatabase(
        join(await getDatabasesPath(), 'libri.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE libri (id INTEGER PRIMARY KEY AUTOINCREMENT, titolo TEXT NOT NULL, autori TEXT, numeroPagine INTEGER, genere TEXT, lingua TEXT, trama TEXT, isbn TEXT NOT NULL, dataPubblicazione TEXT, voto REAL, copertina TEXT, note TEXT, urlimg TEXT, stato TEXT);',
          );
        },
        version: 1,
      );
    })();

Future<void> insertLibro(Libro libro) async {
  final db = await libri;
  await db.insert(
    'libri',
    libro.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// A method that retrieves all the dogs from the dogs table.
Future<List<Libro>> getLibri() async {
  // Get a reference to the database.
  final db = await libri;

  // Query the table for all the dogs.
  final List<Map<String, Object?>> libriMap = await db.query('libri');

  // Convert the list of each dog's fields into a list of `Dog` objects.
  return [
    for (final libroMap in libriMap)
      Libro(
        id: libroMap['id'] as int,
        titolo: libroMap['titolo'] as String,
        autori: libroMap['autori'] as String?,
        numeroPagine: libroMap['numeroPagine'] as int?,
        genere:
            libroMap['genere'] != null
                ? GenereLibro.values.firstWhere(
                  (g) => g.toString() == 'GenereLibro.${libroMap['genere']}',
                )
                : null,
        lingua: libroMap['lingua'] as String?,
        trama: libroMap['trama'] as String?,
        isbn: libroMap['isbn'] as String,
        dataPubblicazione:
            libroMap['dataPubblicazione'] != null
                ? DateTime.tryParse(libroMap['dataPubblicazione'] as String)
                : null,
        voto:
            libroMap['voto'] != null
                ? (libroMap['voto'] as num).toDouble()
                : null,
        copertina: libroMap['copertina'] as String?,
        note: libroMap['note'] as String?,
        urlimg: libroMap['urlimg'] as String?,
        stato:
            libroMap['stato'] != null
                ? StatoLibro.values.firstWhere(
                  (s) => s.toString() == 'StatoLibro.${libroMap['stato']}',
                )
                : null,
      ),
  ];
}

Future<void> deleteLibro(int id) async {
  // Get a reference to the database.
  final db = await libri;

  // Remove the Dog from the database.
  await db.delete(
    'libri',
    // Use a `where` clause to delete a specific libro.
    where: 'id = ?',
    // Pass the libro's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
}

Future<void> updateLibro(Libro libro) async {
  // Get a reference to the database.
  final db = await libri;

  // Update the given Dog.
  await db.update(
    'libri',
    libro.toMap(),
    // Ensure that the Libro has a matching id.
    where: 'id = ?',
    // Pass the Libro's id as a whereArg to prevent SQL injection.
    whereArgs: [libro.id],
  );
}
