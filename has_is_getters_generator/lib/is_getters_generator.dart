library is_getters_generator;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:has_is_getters/has_is_getters.dart';
import 'package:source_gen/source_gen.dart';

import 'code_gen_error.dart';

Builder generateIsGetters(BuilderOptions options) =>
    SharedPartBuilder([IsGettersGenerator()], 'is_getters');

class IsGettersGenerator extends GeneratorForAnnotation<GenerateIsGetters> {
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, _) {
    final usePrefix = annotation.read('usePrefix').objectValue.toBoolValue();
    final generateNegation =
        annotation.read('generateNegation').objectValue.toBoolValue();

    if (element is! FieldElement) {
      throw CodeGenError('You can only annotate fields.');
    }

    final field = element as FieldElement;
    final fieldName = field.name;
    final className = field.enclosingElement.name;
    assert(fieldName != null);
    assert(className != null);

    if (field.getter == null) {
      throw CodeGenError('The field must have a getter.');
    }

    final type = field.type as ClassElement;
    final enumValues = type.fields.where(
      (field) => !['values', 'index'].contains(field.name),
    );
    assert(enumValues.isNotEmpty);

    if (!type.isEnum) {
      throw CodeGenError("You annotated the $className\'s $fieldName with "
          "@GenerateIsGetters(), but that's of "
          "${type == null ? 'an unknown type.' : 'the type ${type.name}, which is not an enum.'} "
          "@GenerateIsGetters() should only be used on fields of an enum "
          "type.");
    }

    // When import prefixes (`import '...' as xyz;`) are used in the file, then
    // in the generated file, we need to use the right prefix in front of the
    // type (`xyz.`). So here, we find out the type prefix.
    final prefixOrNull = field.library.imports
        .firstWhere((import) {
          return type.library.identifier == import.importedLibrary.identifier;
        }, orElse: () => null)
        ?.prefix
        ?.name;
    final typePrefix = prefixOrNull == null ? '' : '$prefixOrNull.';

    final prefix = 'is${usePrefix ? _capitalize(field.name) : ''}';

    List<String> generateGetters(FieldElement value) {
      final valueName = value.name;
      final capitalizedValueName = _capitalize(valueName);
      return [
        'bool get $prefix$capitalizedValueName => $fieldName == $typePrefix$valueName',
        if (generateNegation)
          'bool get ${prefix}Not$capitalizedValueName => $fieldName != $typePrefix$valueName',
      ];
    }

    // Actually generate the extension.
    final buffer = StringBuffer();
    buffer.writeAll([
      'extension $className${fieldName}IsGetters on $className {',
      for (final value in enumValues) ...generateGetters(value),
      '}',
    ].expand((line) => [line, '\n']));
    return buffer.toString();
  }

  /// Capitalizes the first letter of a string.
  String _capitalize(String string) {
    assert(string.isNotEmpty);
    return string[0].toUpperCase() + string.substring(1);
  }
}
