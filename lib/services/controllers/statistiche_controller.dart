import '../../models/genere_libro_model.dart';
import '../../models/libreria_model.dart';
import '../../models/stato_libro_model.dart';

/// Controller per la gestione delle statistiche della libreria.
///
/// Questa classe si occupa di raccogliere e calcolare tutte le statistiche
/// utili per la visualizzazione nella schermata delle statistiche,
/// separando la logica di business dalla vista.
class StatisticheController {
  final Libreria libreria;

  /// Crea un nuovo controller per le statistiche.
  ///
  /// [libreria] è l'istanza della libreria su cui calcolare le statistiche.
  StatisticheController(this.libreria);

  /// Restituisce una mappa che associa ogni stato dei libri al numero di libri in quello stato.
  ///
  /// Utilizza tutti i valori possibili dello stato [StatoLibro].
  /// @return Mappa con chiave [StatoLibro] e valore il conteggio dei libri.
  Map<StatoLibro, int> getConteggioPerStato() {
    final libri = libreria.getLibri();
    final stati = StatoLibro.values;
    return {
      for (var stato in stati)
        stato: libri.where((l) => l.stato == stato).length,
    };
  }

  /// Restituisce il numero di libri che hanno note non vuote.
  ///
  /// @return Numero di libri con note.
  int getNumNote() {
    return libreria
        .getLibri()
        .where((l) => (l.note?.isNotEmpty ?? false))
        .length;
  }

  /// Restituisce il numero di libri che hanno un voto assegnato.
  ///
  /// @return Numero di libri recensiti.
  int getNumRecensioni() {
    return libreria.getLibri().where((l) => l.voto != null).length;
  }

  /// Restituisce una lista con tutti i voti assegnati ai libri.
  ///
  /// @return Lista di voti dei libri recensiti.
  List<double> getListaVoti() {
    return libreria
        .getLibri()
        .where((l) => l.voto != null)
        .map((l) => l.voto!)
        .toList();
  }

  /// Restituisce una lista con i titoli dei libri che hanno un voto assegnato.
  ///
  /// @return Lista di titoli dei libri recensiti.
  List<String> getTitoliLibriConVoto() {
    return libreria
        .getLibri()
        .where((l) => l.voto != null)
        .map((l) => l.titolo)
        .toList();
  }

  /// Calcola e rest1ituisce la media dei voti assegnati ai libri.
  ///
  /// Se non ci sono libri recensiti, restituisce 0.
  /// @return Media dei voti.
  double getMediaVoto() {
    final votiLibri =
        libreria
            .getLibri()
            .where((l) => l.voto != null)
            .map((l) => l.voto!)
            .toList();
    return votiLibri.isNotEmpty
        ? votiLibri.reduce((a, b) => a + b) / votiLibri.length
        : 0.0;
  }

  /// Calcola il numero di pagine lette e il tempo stimato di lettura.
  ///
  /// Considera solo i libri nello stato "letto" e con un numero di pagine valido.
  /// Il tempo stimato è calcolato come 5 minuti per pagina.
  /// @return Mappa con chiavi: 'pagineLette', 'ore', 'minuti'.
  Map<String, dynamic> getPagineLetteETempo() {
    final libri = libreria.getLibri();
    int pagineLette = 0;
    libri
        .where((l) => l.stato == StatoLibro.letto && l.numeroPagine != null)
        .forEach((libro) {
          pagineLette += libro.numeroPagine!;
        });
    int tempoTotaleMinuti = pagineLette * 5;
    int ore = tempoTotaleMinuti ~/ 60;
    int minuti = tempoTotaleMinuti % 60;
    return {'pagineLette': pagineLette, 'ore': ore, 'minuti': minuti};
  }

  /// Restituisce una mappa che associa ogni genere di libro al numero di libri letti di quel genere.
  ///
  /// Considera solo i libri nello stato "letto".
  /// @return Mappa con chiave [GenereLibro] e valore il conteggio dei libri letti.
  Map<GenereLibro, int> getConteggioGeneri() {
    final libriLetti = libreria.getLibriPerStato(StatoLibro.letto);
    final Map<GenereLibro, int> conteggioGeneri = {};
    for (var libro in libriLetti) {
      if (libro.genere != null) {
        conteggioGeneri.update(
          libro.genere!,
          (val) => val + 1,
          ifAbsent: () => 1,
        );
      }
    }
    return conteggioGeneri;
  }
}
