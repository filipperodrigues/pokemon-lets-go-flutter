import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:pokemon_lets_go_flutter/domain/pokemon_item_list_model.dart';
import 'package:pokemon_lets_go_flutter/extensions/color_helper.dart';
import 'package:pokemon_lets_go_flutter/repositories/pokemon_repository.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController;

  PokemonRepository _pokemonRepository;

  /// Quantidade de pokémon por get
  int _pokemonListLimit = 20;
  /// Quantidade de pokémon pulado por get
  int _pokemonListOffset = 0;

  List<PokemonItemListModel> _pokemonList;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _pokemonRepository = PokemonRepository();

    _scrollController = ScrollController();
    _scrollController.addListener(_listenScrollController);

    _getAllPokemon();
  }

  void _getAllPokemon() async {
    // Se nunca carregou, usa o loader de tela inteira
    final withLoading = _pokemonList == null;

    if (withLoading) {
      setState(() => _isLoading = true);
    }

    final remoteList = await _pokemonRepository.getAll(
      limit: _pokemonListLimit,
      offset: _pokemonListOffset
    );

    // Adiciona 20 para "passar de página"
    _pokemonListOffset += 20;

    final actualList = _pokemonList ?? [];
    // Soma as duas listas e remove duplicatas
    final newList = (actualList + remoteList).toSet().toList();

    setState(() {
      _isLoading = false;
      _pokemonList = newList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoader();
    } else {
      return _buildList();
    }
  }

  Widget _buildLoader() {
    return LinearProgressIndicator();
  }

  Widget _buildList() {
    if (_pokemonList == null) {
      return const SizedBox();
    }

    if (_pokemonList.isEmpty) {
      return Center(
        child: Text('Nenhum pokémon encontrado na grama alta')
      );
    }

    return ListView.separated(
      key: const PageStorageKey('myListView'),
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      separatorBuilder: (context, index) => const SizedBox(height: 16.0),
      itemCount: _pokemonList.length + 1,
      itemBuilder: (context, index) {
        if (_pokemonList.length > index) {
          final pokemon = _pokemonList[index];

          return _buildPokemonCard(pokemon);
        } else {
          return _buildBottomLoader();
        }            
      },
    );
  }

  Widget _buildBottomLoader() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: double.infinity,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildPokemonCard(PokemonItemListModel pokemon) {
    final imageProvider = NetworkImage(pokemon.spriteUrl);

    return FutureBuilder<Color>(
      future: _getMainColor(imageProvider),
      initialData: Colors.white,
      builder: (context, snapshot) {
        final cardColor = snapshot.data;

        return Card(
          margin: const EdgeInsets.all(0.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: double.infinity,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: const BorderRadius
                .all(Radius.circular(4.0))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${pokemon.pokemonId}',
                        style: TextStyle(
                          color: cardColor.constrast()
                        ),
                      ),
                      Text(
                        pokemon.nameDisplay,
                        style: TextStyle(
                          color: cardColor.constrast(),
                          fontSize: 18.0
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    _buildPokeBallImage(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: NetworkImage(pokemon.spriteUrl)
                        )
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  /// Escuta o scroll
  void _listenScrollController() {
    // Caso esteja no fim da lista, manda carregar mais pokémon
    if (_scrollController.position.atEdge) {
      _getAllPokemon();
    }
  }

  Widget _buildPokeBallImage() {
    return Positioned.fill(
      right: 0.0,
      top: - 10.0,
      bottom: - 10.0,
      child: Transform.rotate(
        angle: 0.5,
        child: Opacity(
          opacity: 0.5,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage('assets/poke_ball.png')
              )
            ),
          ),
        ),
      ),
    );
  }

  /// Devolve a cor dominante de uma imagem
  Future<Color> _getMainColor(ImageProvider imageProvider) async {
    final paletteGenerator = await PaletteGenerator
        .fromImageProvider(imageProvider);

    return paletteGenerator.dominantColor.color;
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Text(
        "Let's GO Flutter",
        style: const TextStyle(
          color: Colors.black
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}