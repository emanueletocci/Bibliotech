import 'dart:io';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p; // Importa per la manipolazione dei percorsi

class FileUtility {
  // Ottiene la directory dell'applicazione
  static Future<String> get _localPath async { 
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Metodo per ottenere un riferimento ad un file
  static Future<File> _localFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  // Metodo per scrivere una stringa in un file
  static Future<File> writeTextToFile(String filename, String text) async { 
    final file = await _localFile(filename); // Usa il parametro filename
    return file.writeAsString(text);
  }

  // Metodo per leggere una stringa da un file
  static Future<String> readTextFile(String filename) async { 
    try {
      final file = await _localFile(filename); // Usa il parametro filename
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "No Data";
    }
  }

  // Metodo per salvare un file (es. un'immagine) nella directory dell'app
  static Future<File> saveFile(File sourceFile, String filename) async {
    final path = await _localPath;
    final newPath = p.join(path, filename);
    return sourceFile.copy(newPath);
  }

   // Metodo per eliminare un file
  static Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}

