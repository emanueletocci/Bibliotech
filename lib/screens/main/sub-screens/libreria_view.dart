import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/libreria_model.dart';
import '../../../components/libro_cover_widget.dart';
import '../../../models/genere_libro_model.dart';
import '../../../models/stato_libro_model.dart';
import '../../dettagli_libro/dettagli_libro_view.dart';

/// Schermata che mostra la libreria dell'utente.
///
/// Permette di filtrare i libri per genere, stato, preferiti e titolo.
/// Visualizza i libri in una griglia e consente di accedere ai dettagli.
class LibreriaView extends StatefulWidget {
  /// Costruttore della schermata Libreria.
  const LibreriaView({super.key});

  @override
  State<LibreriaView> createState() => _LibreriaViewState();
}

class _LibreriaViewState extends State<LibreriaView> {
  GenereLibro? _genereSelezionato;
  StatoLibro? _statoSelezionato;
  String? _titoloSelezionato;
  bool _soloPreferiti = false;

  @override
  void initState() {
    super.initState();
  }

  /// Imposta il filtro per genere.
  void _filtraPerGenere(GenereLibro? genere) {
    setState(() => _genereSelezionato = genere);
  }

  /// Imposta il filtro per stato di lettura.
  void _filtraPerStato(StatoLibro? stato) {
    setState(() => _statoSelezionato = stato);
  }

  /// Imposta il filtro per visualizzare solo i preferiti.
  void _filtraPerPreferiti(bool soloPreferiti) {
    setState(() => _soloPreferiti = soloPreferiti);
  }

  /// Imposta il filtro per titolo (ricerca).
  void _filtraPerTitolo(String? titolo) {
    setState(() => _titoloSelezionato = titolo);
  }

  @override
  Widget build(BuildContext context) {
    final libreria = context.watch<Libreria>();

    final libriFiltrati = libreria.getLibriFiltrati(
      genere: _genereSelezionato,
      stato: _statoSelezionato,
      soloPreferiti: _soloPreferiti,
      titolo: _titoloSelezionato,
    );

    final orientamento = MediaQuery.of(context).orientation;
    final crossAxisCount = orientamento == Orientation.portrait ? 3 : 5;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Sezione dei filtri in alto.
              SezioneFiltri(
                genereSelezionato: _genereSelezionato,
                statoSelezionato: _statoSelezionato,
                filtraPerGenere: _filtraPerGenere,
                filtraPerStato: _filtraPerStato,
                soloPreferiti: _soloPreferiti,
                filtraPerPreferiti: _filtraPerPreferiti,
                filtraPerTitolo: _filtraPerTitolo,
              ),
              Divider(
                color: Theme.of(context).colorScheme.outline,
                thickness: 1.0,
              ),

              /// Griglia dei libri filtrati oppure messaggio "nessun libro".
              libriFiltrati.isEmpty
                  ? const Center(child: Text("Nessun libro presente."))
                  : GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      physics: const NeverScrollableScrollPhysics(),
                      children: libriFiltrati.map((libro) {
                        return SizedBox(
                          width: 150,
                          height: 150,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DettagliLibroView(libro: libro),
                                ),
                              );
                              debugPrint(
                                  'Hai premuto il libro: ${libro.titolo}');
                            },
                            borderRadius: BorderRadius.circular(8.0),
                            child: LibroCoverWidget(libro: libro),
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Barra orizzontale per selezionare il genere del libro.
class GeneriBar extends StatelessWidget {
  /// Genere attualmente selezionato.
  final GenereLibro? genereSelezionato;

  /// Callback quando viene selezionato un genere.
  final Function(GenereLibro?) onGenereSelezionato;

  /// Costruttore.
  const GeneriBar({
    super.key,
    required this.genereSelezionato,
    required this.onGenereSelezionato,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Opzione "Tutti"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => onGenereSelezionato(null),
                  child: Container(
                    width: 50,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: genereSelezionato == null
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            )
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        color:
                            Theme.of(context).colorScheme.surfaceContainer,
                        child: Icon(
                          Icons.all_inclusive,
                          size: 36,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Tutti",
                  style: TextStyle(
                    fontWeight: genereSelezionato == null
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: genereSelezionato == null
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          // Generi dinamici
          ...GenereLibro.values.map((genere) {
            final isSelected = genereSelezionato == genere;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => onGenereSelezionato(genere),
                    child: Container(
                      width: 50,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(
                                color:
                                    Theme.of(context).colorScheme.primary,
                                width: 2,
                              )
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          genere.percorsoImmagine,
                          fit: BoxFit.cover,
                          color: isSelected
                              ? null
                              : Colors.black.withAlpha(60),
                          colorBlendMode: isSelected
                              ? null
                              : BlendMode.darken,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    genere.titolo,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Barra per selezionare lo stato di lettura dei libri.
class StatiLibriBar extends StatelessWidget {
  /// Stato selezionato.
  final StatoLibro? statoSelezionato;

  /// Callback quando viene selezionato uno stato.
  final Function(StatoLibro?) onStatoSelezionato;

  /// Costruttore.
  const StatiLibriBar({
    super.key,
    required this.statoSelezionato,
    required this.onStatoSelezionato,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> chips = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: FilterChip(
          label: const Text("Tutti"),
          selected: statoSelezionato == null,
          onSelected: (_) => onStatoSelezionato(null),
          avatar: const Icon(Icons.all_inclusive),
        ),
      ),
      ...StatoLibro.values.map((stato) {
        final isSelected = statoSelezionato == stato;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: FilterChip(
            label: Text(stato.titolo),
            selected: isSelected,
            onSelected: (selected) =>
                onStatoSelezionato(selected ? stato : null),
            avatar: Icon(stato.icona),
          ),
        );
      }),
    ];

    return SizedBox(
      height: 56,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemCount: chips.length,
        itemBuilder: (context, index) => chips[index],
      ),
    );
  }
}

/// Sezione contenente tutti i filtri combinati: titolo, genere, stato, preferiti.
class SezioneFiltri extends StatelessWidget {
  /// Genere selezionato.
  final GenereLibro? genereSelezionato;

  /// Stato selezionato.
  final StatoLibro? statoSelezionato;

  /// Visualizza solo preferiti.
  final bool soloPreferiti;

  /// Callback per filtrare per genere.
  final Function(GenereLibro?) filtraPerGenere;

  /// Callback per filtrare per stato.
  final Function(StatoLibro?) filtraPerStato;

  /// Callback per filtrare per preferiti.
  final Function(bool) filtraPerPreferiti;

  /// Callback per filtrare per titolo.
  final Function(String?) filtraPerTitolo;

  /// Costruttore.
  const SezioneFiltri({
    super.key,
    required this.genereSelezionato,
    required this.statoSelezionato,
    required this.soloPreferiti,
    required this.filtraPerGenere,
    required this.filtraPerStato,
    required this.filtraPerPreferiti,
    required this.filtraPerTitolo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RicercaLibri(onChanged: filtraPerTitolo),
        const SizedBox(height: 10),
        GeneriBar(
          genereSelezionato: genereSelezionato,
          onGenereSelezionato: filtraPerGenere,
        ),
        StatiLibriBar(
          statoSelezionato: statoSelezionato,
          onStatoSelezionato: filtraPerStato,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: FilterChip(
              label: const Text("Preferiti"),
              selected: soloPreferiti,
              onSelected: filtraPerPreferiti,
              avatar: const Icon(Icons.favorite),
            ),
          ),
        ),
      ],
    );
  }
}

/// Campo di ricerca per filtrare i libri per titolo.
class RicercaLibri extends StatefulWidget {
  /// Callback chiamata quando il testo cambia.
  final Function(String?) onChanged;

  /// Costruttore.
  const RicercaLibri({super.key, required this.onChanged});

  @override
  State<RicercaLibri> createState() => _RicercaLibriState();
}

class _RicercaLibriState extends State<RicercaLibri> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (value) =>
          widget.onChanged(value.isEmpty ? null : value),
      decoration: const InputDecoration(
        labelText: "Cerca per titolo",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
    );
  }
}
