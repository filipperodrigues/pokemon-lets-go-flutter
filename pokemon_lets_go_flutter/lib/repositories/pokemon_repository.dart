import 'package:http/http.dart' as http;
import 'package:pokemon_lets_go_flutter/domain/pokemon_item_list_model.dart';
import 'package:pokemon_lets_go_flutter/core/constants.dart';
import 'dart:convert';

class PokemonRepository {
  final String endpoint = 'pokemon';
  /// Retorna uma lista paginada de pokémon
  /// 
  /// [limit] é a quantidade que vai ser retornada
  /// [offset] é quantos pokémon serão pulados
  /// exemplos:
  /// [limit] = 20, [offset] = 0 -> página 1
  /// [limit] = 20, [offeset] = 20 -> página 2
  Future<List<PokemonItemListModel>> getAll({int limit = 20, int offset = 0}) async {
    final response = await http.get(
      '$SERVER_URL/$endpoint?limit=$limit&offset=$offset'
    );

    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

    // Percorre cada resultado da listagem e converte para objeto [PokemonItemListModel]
    return (responseJson['results'] as List)
      .map((e) => PokemonItemListModel.fromJson(e)).toList();
  }
}