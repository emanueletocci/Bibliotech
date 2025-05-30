import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bibliotech/models/libro_model.dart';

/// Helper per la gestione del database SQLite dell'app.
/// Implementa il pattern Singleton e fornisce metodi CRUD per la tabella 'libri'.
class DatabaseHelper {
  // Singleton
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  /// Restituisce l'istanza singleton di [DatabaseHelper].
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  /// Restituisce il database, inizializzandolo se necessario.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Inizializza il database e crea la tabella se necessario.
  Future<Database> _initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'libri.db'),
      onCreate: _onCreate,
      version: 3,
    );
  }

  /// Callback per la creazione della tabella 'libri' nel database.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE libri (
      isbn TEXT PRIMARY KEY,
      titolo TEXT NOT NULL,
      autori TEXT,
      numeroPagine INTEGER,
      genere TEXT,
      lingua TEXT,
      trama TEXT,
      dataPubblicazione TEXT,
      voto REAL,
      copertina TEXT,
      note TEXT,
      stato TEXT,
      publisher TEXT, 
      preferito INTEGER
    )
    ''');
  }

  // -- OPERAZIONI CRUD --

  /// Inserisce un nuovo [libro] nella tabella 'libri'.
  Future<void> insertLibro(Libro libro) async {
    final db = await database;
    await db.insert(
      'libri',
      libro.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Elimina il libro con l'[isbn] specificato dalla tabella 'libri'.
  Future<void> deleteLibro(String isbn) async {
    final db = await database;
    await db.delete('libri', where: 'isbn = ?', whereArgs: [isbn]);
  }

  /// Aggiorna i dati di un [libro] esistente nella tabella 'libri'.
  Future<void> updateLibro(Libro libro) async {
    final db = await database;
    await db.update(
      'libri',
      libro.toMap(),
      where: 'isbn = ?',
      whereArgs: [libro.isbn],
    );
  }

  /// Restituisce il libro con l'[isbn] specificato, oppure null se non trovato.
  Future<Libro?> getLibro(String isbn) async {
    final db = await database;
    final result = await db.query(
      'libri',
      where: 'isbn = ?',
      whereArgs: [isbn],
      limit: 1,
    );
    // Se trovo il libro con l'ISBN specificato, lo converto in un oggetto Libro e lo restituisco
    // Altrimenti restituisco null
    return result.isNotEmpty ? Libro.fromMap(result.first) : null;
  }

  /// Restituisce la lista di tutti i libri presenti nella tabella 'libri'.
  Future<List<Libro>> getAllLibri() async {
    final db = await database;
    final result = await db.query('libri');
    return result.map((map) => Libro.fromMap(map)).toList();
  }

  /// Chiude la connessione al database.
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
