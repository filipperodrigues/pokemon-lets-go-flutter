import 'package:pokemon_lets_go_flutter/core/constants.dart';

class PokemonItemListModel {
  final String name;
  final String url;

  String get pokemonId {
    // Quebra a URL nas barras
    final urlSplitted = url.split('/');
    // Penúltimo elemento é o id
    final pokemonId = urlSplitted[urlSplitted.length - 2];

    return pokemonId;
  }

  /// Coloca letra maiúscula no nome do Pokémon
  String get nameDisplay {
    return name.replaceFirst(name[0], name[0].toUpperCase());
  }

  /// Devolve a url da sprite do Pokémon
  String get spriteUrl {
    return '$SPRITE_URL/$pokemonId.png';
  }

  const PokemonItemListModel({
    this.name, 
    this.url
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  factory PokemonItemListModel.fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return PokemonItemListModel(
      name: map['name'],
      url: map['url'],
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is PokemonItemListModel &&
      o.pokemonId == pokemonId;
  }

  @override
  int get hashCode => pokemonId.hashCode;
}
