// Questa classe rappresenta un modello per le citazioni mostrate nella homepage
class Citazione {
  final String testo;
  final String autore;
  final String libro;

  const Citazione({
    required this.testo,
    required this.autore,
    required this.libro,
  });

  // Costruttore factory per creare un'istanza da un JSON
  factory Citazione.fromJson(Map<String, dynamic> json) {
    return Citazione(
      testo: json['testo'] as String,
      autore: json['autore'] as String,
      libro: json['libro'] as String,
    );
  }
}
