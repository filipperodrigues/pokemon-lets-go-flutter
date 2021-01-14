import 'package:pokemon_lets_go_flutter/domain/pokemon_item_list_model.dart';

class PokemonRepository {
  /// Retorna dados mockados com a ideia de ter uma descrição para cada Pokémon,
  /// facilitando a usabilidade para leitores de tela, sendo que estes agora
  /// terão alguma informação para explicar como é o Pokémon.
  Future<List<PokemonItemListModel>> getAll() async {
    return const [
      PokemonItemListModel(
        name: 'bulbasaur',
        url: 'https://pokeapi.co/api/v2/pokemon/1/',
        description:
            'Bulbassauro, é um Pokémon tipo Planta e Venenoso. Ele evolui para Ivyssauro a partir do nível 16, e evolui para Venossauro a partir do nível 32.',
      ),
      PokemonItemListModel(
        name: 'ivysaur',
        url: 'https://pokeapi.co/api/v2/pokemon/2/',
        description:
            'Ivyssauro, é um Pokémon do tipo grama e venenoso. Ele é a forma evoluida de Bulbassauro quando chega no nível 16 e evolui para Venossauro quando chega no nível 32.',
      ),
      PokemonItemListModel(
        name: 'venusaur',
        url: 'https://pokeapi.co/api/v2/pokemon/3/',
        description:
            'Venossauro, é um Pokémon do tipo grama e venenoso. Ele é a forma evoluída de Ivysaur quando chega no nível 32.',
      ),
      PokemonItemListModel(
        name: 'charmander',
        url: 'https://pokeapi.co/api/v2/pokemon/4/',
        description:
            'Charmander, é um Pokémon tipo fogo. Ele evolui para Charmeleon quando chega no nivel 16 e depois evolui para Charizard quando chega no nivel 36.',
      ),
      PokemonItemListModel(
        name: 'charmeleon',
        url: 'https://pokeapi.co/api/v2/pokemon/5/',
        description:
            'Charmeleon, é um Pokémon do tipo Fogo. Ele é a forma evoluida de Charmander quando chega no nivel 16 e depois evolui para Charizard quando chega no nivel 36.',
      ),
      PokemonItemListModel(
        name: 'charizard',
        url: 'https://pokeapi.co/api/v2/pokemon/6/',
        description:
            'Charizard, é um Pokémon do tipo Fogo e Voador. Ele é a forma evoluída de Charmeleon quando chega no nível 36. Ele tambem é a forma final de Charmander.',
      ),
    ];
  }
}
