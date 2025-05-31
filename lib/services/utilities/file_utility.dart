import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p; // Manipolazione dei percorsi

/// Classe di utilità per la gestione dei file.
/// Fornisce metodi statici per leggere, scrivere, salvare ed eliminare file.
class FileUtility {
  /// Ottiene il percorso della directory dell'applicazione.
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Restituisce un riferimento a un file nella directory locale dato il [filename].
  static Future<File> _localFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  /// Scrive una stringa [text] in un file chiamato [filename].
  /// Restituisce il file scritto.
  static Future<File> writeTextToFile(String filename, String text) async {
    final file = await _localFile(filename); // Usa il parametro filename
    return file.writeAsString(text);
  }

  /// Legge e restituisce il contenuto di un file [filename] come stringa.
  /// Restituisce "No Data" se il file non esiste o si verifica un errore.
  static Future<String> readTextFile(String filename) async {
    try {
      final file = await _localFile(filename); // Usa il parametro filename
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "No Data";
    }
  }

  /// Salva un file [sourceFile] nella directory dell'app con nome [filename].
  /// Restituisce il nuovo file copiato.
  static Future<File> saveFile(File sourceFile, String filename) async {
    final path = await _localPath;
    final newPath = p.join(path, filename);
    return sourceFile.copy(newPath);
  }

  /// Elimina il file specificato dal percorso [filePath].
  static Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
