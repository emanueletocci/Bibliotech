import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/libreria.dart';
import '../../components/libro_cover_widget.dart';
import '../../models/genere_libro.dart';
import '../../models/stato_libro.dart';
import '../dettagli_libro/dettagli_libro_view.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';

class LibreriaPage extends StatefulWidget {
  const LibreriaPage({super.key});

  @override
  State<LibreriaPage> createState() => _LibreriaPageState();
}

class _LibreriaPageState extends State<LibreriaPage> {
  // Variabile per tenere traccia del genere selezionato
  // Se null, nessun genere è selezionato e si mostrano tutti i libri
  GenereLibro? _genereSelezionato;
  StatoLibro? _statoSelezionato;
  bool _soloPreferiti = false;

  // Controller necessario a nascondere i filtri quando si scorre verso il basso
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Callback per l'aggiornamento dello stato in base al genere selezionato
  void _filtraPerGenere(GenereLibro? genere) {
    setState(() => _genereSelezionato = genere);
  }

  // Callback per l'aggiornamento dello stato in base allo stato del libro selezionato

  void _filtraPerStato(StatoLibro? stato) {
    setState(() => _statoSelezionato = stato);
  }

  void _filtraPerPreferiti(bool soloPreferiti) {
    setState(() => _soloPreferiti = soloPreferiti);
  }

  @override
  Widget build(BuildContext context) {
    final libreria = context.watch<Libreria>();

    // Ottengo la lista di libri filtrati.
    // Se il genere non è selezionato, prendo automaticamente tutti i libri
    // La lista viene ricreata ad ogni build, quindi ad ogni cambiamento di stato
    final libriFiltrati = libreria.getLibriFiltrati(
      genere: _genereSelezionato,
      stato: _statoSelezionato,
      soloPreferiti: _soloPreferiti,
    );

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Questa sezione deve essere nascondibile quando si scorre verso il basso
              ScrollToHide(
                scrollController: _scrollController,
                hideDirection: Axis.vertical,
                child: SezioneFiltri(
                  genereSelezionato: _genereSelezionato,
                  statoSelezionato: _statoSelezionato,
                  filtraPerGenere: _filtraPerGenere,
                  filtraPerStato: _filtraPerStato,
                  soloPreferiti: _soloPreferiti,
                  filtraPerPreferiti: _filtraPerPreferiti,
                ),
              ),
                      libriFiltrati.isEmpty
                          ? const Center(child: Text("Nessun libro presente."))
                          : GridView.count(
                            shrinkWrap: true, // il gridview deve adattarsi alla dimensione dei suoi figli, occupando solo lo spazio necessario
                            crossAxisCount: 3,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            physics: const NeverScrollableScrollPhysics(), // Disabilito lo scroll interno del GridView
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
                                                    DettagliLibro(libro: libro),
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

// Widget per la barra di ricerca personalizzata
class SearchBarCustom extends StatelessWidget {
  const SearchBarCustom({super.key});
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(21)),
        hintText: 'Cerca un libro!',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}

// Widget per la barra dei filtri basata sui generi dei libri
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
              mainAxisSize: MainAxisSize.min, // <-- aggiungi questa riga
              children: [
                GestureDetector(
                  // Gestore del tap per il filtro "Tutti"
                  // impostando null, ottengo la lista completa dei libri
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
                        // Imposto i colori del container "Tutti" (altrimenti si vede solo l'icona)
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
                mainAxisSize: MainAxisSize.min, // <-- aggiungi questa riga
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
                          // Applico un filtro di colore se il genere non é selezionato
                          // BlendMode.darken rende l'immagine più scura e va lasciato altrimenti flutter ne applica
                          // uno di default che renderizza l'immagine di colore grigio, come specificato dal color
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

// Widget per la barra dei filtri basata sugli stati dei libri
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
    // Lista completa dei chip: "Tutti" + tutti gli stati
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
        // Di default, ListView ha un'altezza infinita, quindi devo specificare un'altezza o wrappare la lista
        // in un widget con altezza fissa. Con shrinkWrap: true, la lista si adatta alle dimensioni dei suoi figli.
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemCount: chips.length,
        itemBuilder: (context, index) => chips[index],
      ),
    );
  }
}

// Widget wrapper per la sezione dei filtri. Creo un unico widget che ingloba tutto l'header della pagina,
// ossia tuta la sezione dedicata ai filtri. Ció mi semplifica la gestione dello scroll_to_hide
class SezioneFiltri extends StatelessWidget {
  final GenereLibro? genereSelezionato;
  final StatoLibro? statoSelezionato;
  final bool soloPreferiti;
  final Function(GenereLibro?) filtraPerGenere;
  final Function(StatoLibro?) filtraPerStato;
  final Function(bool) filtraPerPreferiti;

  const SezioneFiltri({
    super.key,
    required this.genereSelezionato,
    required this.statoSelezionato,
    required this.soloPreferiti,
    required this.filtraPerGenere,
    required this.filtraPerStato,
    required this.filtraPerPreferiti,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchBarCustom(),
        // Imposto manualmente la spaziatura in quanto i chips hanno un'altezza fissa di default
        // Con spacing li distanzio troppo, quindi uso SizedBox
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
