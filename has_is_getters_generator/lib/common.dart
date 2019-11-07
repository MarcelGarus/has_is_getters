import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class CodeGenError extends Error {
  CodeGenError(this.message);

  final String message;

  String toString() => message;
}

/// Capitalizes the first letter of a string.
String capitalize(String string) {
  assert(string.isNotEmpty);
  return string[0].toUpperCase() + string.substring(1);
}

abstract class GeneratorForAnnotatedField<AnnotationType> extends Generator {
  /// Returns the annotation of type [AnnotationType] of the given [element],
  /// or [null] if it doesn't have any.
  DartObject getAnnotation(Element element) {
    final annotations =
        TypeChecker.fromRuntime(AnnotationType).annotationsOf(element);
    if (annotations.isEmpty) {
      return null;
    }
    if (annotations.length > 1) {
      throw CodeGenError(
          "You tried to add multiple @$AnnotationType() annotations to the "
          "same element (${element.name}), but that's not possible.");
    }
    return annotations.single;
  }

  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final values = <String>{};

    for (final element in library.allElements) {
      if (element is ClassElement && !element.isEnum) {
        for (final field in element.fields) {
          if (field.getter == null) {
            throw CodeGenError(
                'Fields annotated with @$AnnotationType() should have a '
                'getter.');
          }
          final annotation = getAnnotation(field);
          if (annotation != null) {
            values.add(generateForAnnotatedField(
              field,
              ConstantReader(annotation),
            ));
          }
        }
      }
    }

    return values.join('\n\n');
  }

  String generateForAnnotatedField(
      FieldElement field, ConstantReader annotation);
}
