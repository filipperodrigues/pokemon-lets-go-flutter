import 'dart:async';

import 'package:pokemon_lets_go_flutter/core/base_bloc.dart';
import 'package:pokemon_lets_go_flutter/domain/pokemon_item_list_model.dart';
import 'package:pokemon_lets_go_flutter/presentation/pages/home/home_events.dart';
import 'package:pokemon_lets_go_flutter/repositories/pokemon_repository.dart';
import 'package:rxdart/subjects.dart';

class HomeBloc extends BaseBloc {
  PokemonRepository _pokemonRepository;

  /// Quantidade de pokémon por get
  int _pokemonListLimit = 20;
  /// Quantidade de pokémon pulado por get
  int _pokemonListOffset = 0;

  StreamSubscription _subsEvent;
  
  HomeBloc() {
    _pokemonRepository = PokemonRepository();

    // Escuta os eventos e, para cada um, chama o [_handleEvents]
    _subsEvent = _events.listen(_handleEvents);

    // Busca todos pokemon no momento da criação da classe
    onEventChanged(LoadPokemon());
  }

  /// Faz um "DE/PARA", convertendo o evento recebido para uma chamada de método
  void _handleEvents(HomeEvents event) {
    if (event is LoadPokemon) {
      _handleGetAllPokemon();
    }
  }

  void _handleGetAllPokemon() {
    // Se nunca carregou, usa o loader de tela inteira
    final withLoading = _pokemonController.value == null;

    doOnlineAction(
      withLoading: withLoading,
      action: () async {
        final remoteList = await _pokemonRepository.getAll(
          limit: _pokemonListLimit,
          offset: _pokemonListOffset
        );

        // Adiciona 20 para "passar de página"
        _pokemonListOffset += 20;

        final actualList = _pokemonController.value ?? [];
        // Soma as duas listas e remove duplicatas
        final newList = (actualList + remoteList).toSet().toList();

        _onPokemonListChanged(newList);
      }
    );
  }

  final _pokemonController = BehaviorSubject<List<PokemonItemListModel>>();
  Function(List<PokemonItemListModel>) get _onPokemonListChanged => _pokemonController.sink.add;
  Stream<List<PokemonItemListModel>> get pokemon => _pokemonController.stream;

  final _eventsController = BehaviorSubject<HomeEvents>();
  Function(HomeEvents) get onEventChanged => _eventsController.sink.add;
  Stream<HomeEvents> get _events => _eventsController.stream;

  /// Encerra os controllers quando o objeto morrer
  void dispose() {
    super.dispose();
    _subsEvent?.cancel();

    _pokemonController.drain<dynamic>();
    _pokemonController.close();

    _eventsController.drain<dynamic>();
    _eventsController.close();
  } 
}