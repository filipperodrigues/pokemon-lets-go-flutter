abstract class HomeEvents {
  const HomeEvents();
}

class LoadPokemon extends HomeEvents {
  const LoadPokemon();

  @override
  String toString() => 'Buscando todos pokémon...';
}
