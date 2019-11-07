// ignore_for_file: undefined_getter, uri_has_not_been_generated

import 'package:has_is_getters/has_is_getters.dart';

part 'main.g.dart';

enum Shape { round, curved }

class Fruit {
  @GenerateHasGetter(generateNegation: true)
  int number;

  @GenerateIsGetters(usePrefix: true, generateNegations: true)
  Shape theShape;

  Fruit(this.number, this.theShape);
}

void main() {
  var banana = Fruit(2, Shape.curved);

  print(banana.isTheShapeRound);
  print(banana.isTheShapeNotRound);
  print(banana.hasNumber);
  print(banana.hasNoNumber);

  if (banana.theShape == Shape.round) {
    print('The shape is round.');
  }
}
