import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/libreria_model.dart';
import '../../../components/libro_cover_widget.dart';
import '../../../models/genere_libro_model.dart';
import '../../../models/stato_libro_model.dart';
import '../../dettagli_libro/dettagli_libro_view.dart';

/// Tab della schermata principale che mostra la libreria dell'utente.
/// Permette di filtrare i libri per genere, stato, preferiti e titolo.
/// Visualizza i libri in una griglia e consente di accedere ai dettagli di ciascun libro.
class LibreriaTab extends StatefulWidget {
  /// Costruttore della tab Libreria.
  const LibreriaTab({super.key});

  @override
  State<LibreriaTab> createState() => _LibreriaTabState();
}

class _LibreriaTabState extends State<LibreriaTab> {
  GenereLibro? _genereSelezionato;
  StatoLibro? _statoSelezionato;
  String? _titoloSelezionato;
  bool _soloPreferiti = false;

  @override
  void initState() {
    super.initState();
  }

  /// Callback per filtrare i libri per genere.
  void _filtraPerGenere(GenereLibro? genere) {
    setState(() => _genereSelezionato = genere);
  }

  /// Callback per filtrare i libri per stato.
  void _filtraPerStato(StatoLibro? stato) {
    setState(() => _statoSelezionato = stato);
  }

  /// Callback per filtrare i libri preferiti.
  void _filtraPerPreferiti(bool soloPreferiti) {
    setState(() => _soloPreferiti = soloPreferiti);
  }

  /// Callback per filtrare i libri per titolo.
  void _filtraPerTitolo(String? titolo) {
    setState(() {
      _titoloSelezionato = titolo;
    });
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

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              libriFiltrati.isEmpty
                  ? const Center(child: Text("Nessun libro presente."))
                  : GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    physics: const NeverScrollableScrollPhysics(),
                    children:
                        libriFiltrati.map((libro) {
                          return SizedBox(
                            width: 150,
                            height: 150,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            DettagliLibroView(libro: libro),
                                  ),
                                );
                                debugPrint(
                                  'Hai premuto il libro: ${libro.titolo}',
                                );
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

/// Barra dei filtri per la selezione del genere dei libri.
/// Mostra tutti i generi disponibili e consente di selezionarne uno.
class GeneriBar extends StatelessWidget {
  final GenereLibro? genereSelezionato;
  final Function(GenereLibro?) onGenereSelezionato;

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
                      border:
                          genereSelezionato == null
                              ? Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              )
                              : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        color: Theme.of(context).colorScheme.surfaceContainer,
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight:
                        genereSelezionato == null
                            ? FontWeight.bold
                            : FontWeight.normal,
                    color:
                        genereSelezionato == null
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
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
                        border:
                            isSelected
                                ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                )
                                : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          genere.percorsoImmagine,
                          fit: BoxFit.cover,
                          color: isSelected ? null : Colors.black.withAlpha(60),
                          colorBlendMode: isSelected ? null : BlendMode.darken,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    genere.titolo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color:
                          isSelected
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

/// Barra dei filtri per la selezione dello stato dei libri.
/// Mostra tutti gli stati disponibili e consente di selezionarne uno.
class StatiLibriBar extends StatelessWidget {
  final StatoLibro? statoSelezionato;
  final Function(StatoLibro?) onStatoSelezionato;

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
            onSelected:
                (selected) => onStatoSelezionato(selected ? stato : null),
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

/// Widget wrapper per la sezione dei filtri.
/// Comprende la ricerca per titolo, la barra dei generi, la barra degli stati e il filtro preferiti.
class SezioneFiltri extends StatelessWidget {
  final GenereLibro? genereSelezionato;
  final StatoLibro? statoSelezionato;
  final bool soloPreferiti;
  final Function(GenereLibro?) filtraPerGenere;
  final Function(StatoLibro?) filtraPerStato;
  final Function(bool) filtraPerPreferiti;
  final Function(String?) filtraPerTitolo;
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
              onSelected: (selected) => filtraPerPreferiti(selected),
              avatar: const Icon(Icons.favorite),
            ),
          ),
        ),
      ],
    );
  }
}

/// Campo di ricerca per filtrare i libri per titolo.
/// Chiama la callback [onChanged] ad ogni modifica del testo.
class RicercaLibri extends StatefulWidget {
  final Function(String?) onChanged;

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
      onChanged: (value) {
        widget.onChanged(value.isEmpty ? null : value);
      },
      decoration: const InputDecoration(
        labelText: "Cerca per titolo",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
    );
  }
}
