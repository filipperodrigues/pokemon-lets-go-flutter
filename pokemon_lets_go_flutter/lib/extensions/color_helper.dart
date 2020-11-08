import 'package:flutter/material.dart';

extension ColorHelper on Color {
  /// Obtém a cor branca ou preta, dependendo do maior constraste
  Color constrast() {
    int d = 0;

    final luminance = (0.299 * red + 0.587 * green + 0.114 * blue) / 255;

    if (luminance > 0.5) {
      d = 0; 
    } else {
      d = 255;
    }

    return Color.fromARGB(255, d, d, d);
  }

}