This library lets you annotate fields of classes to automatically generate
getters for checking whether a field is `null` or, in case of enum fields,
checking the value of a field.

```dart
if (fruit.price != null) {             ｜  if (fruit.hasPrice) {
  ...                                  ｜    ...
}                                      ｜  }
if (fruit.color == Color.blue          ｜  if (fruit.isBlue || fruit.isNotOrange) {
    || fruit.color != Color.orange) {  ｜    ...
  ...                                  ｜  }
}                                      ｜
```

Here's how to get started:

**1.** 📦 Add these packages to your dependencies:

```yaml
dependencies:
  has_is_getters: ^0.0.2

dev_dependencies:
  build_runner: ^1.7.1
  has_is_getters_generator: ^0.0.2
```

**2.** 📎 Annotate fields with `@GenerateHasGetter()` or enum fields with
`@GenerateIsGetters()`.

```dart
import 'package:has_is_getters/has_is_getters.dart';

part 'my_file.g.dart';

enum Color { orange, blue }

class Fruit {
  @GenerateHasGetter()
  int price;

  @GenerateIsGetters()
  Color color;
}
```

**3.** 🏭 Run `pub run build_runner build` in the command line (or
`flutter pub run build_runner build`, if you're using Flutter). The
getters will automatically be generated, so you can do stuff like this:

```dart
fruit.hasPrice // equal to: fruit.price != null
fruit.isOrange  // equal to: fruit.color == Color.orange
```

## Negations

You can opt-in to generating negations by customizing the annotations:

```dart
class Paper {
  @GenerateHasGetter(generateNegation: true)
  @GenerateIsGetters(generateNegations: true)
  Color color;
}
```

```dart
paper.hasNoColor
paper.isNotOrange
```

## Prefixes

You can also opt-in to using the field name as a prefix for the getters.

```dart
class Image {
  @GenerateIsGetters(usePrefix: true)
  Color background;
}
```

```dart
image.isBackgroundBlue
```
