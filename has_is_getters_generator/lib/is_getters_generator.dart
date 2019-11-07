library is_getters_generator;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:has_is_getters/has_is_getters.dart';
import 'package:source_gen/source_gen.dart';

import 'common.dart';

Builder generateIsGetters(BuilderOptions options) =>
    SharedPartBuilder([IsGettersGenerator()], 'is_getters');

class IsGettersGenerator extends GeneratorForAnnotatedField<GenerateIsGetters> {
  @override
  String generateForAnnotatedField(
      FieldElement field, ConstantReader annotation) {
    final usePrefix = annotation.read('usePrefix').objectValue.toBoolValue();
    final generateNegations =
        annotation.read('generateNegations').objectValue.toBoolValue();

    final fieldName = field.name;
    final className = field.enclosingElement.name;
    assert(fieldName != null);
    assert(className != null);

    final type = field.type.element as ClassElement;
    if (type is! ClassElement || !type.isEnum) {
      throw CodeGenError("You annotated the $className\'s $fieldName with "
          "@GenerateIsGetters(), but that's of "
          "${type == null ? 'an unknown type.' : 'the type ${type.name}, which is not an enum.'} "
          "@GenerateIsGetters() should only be used on fields of an enum "
          "type.");
    }

    final enumValues = type.fields.where(
      (field) => !['values', 'index'].contains(field.name),
    );
    assert(enumValues.isNotEmpty);

    // When import prefixes (`import '...' as xyz;`) are used in the file, then
    // in the generated file, we need to use the right prefix in front of the
    // type (`xyz.`). So here, we find out the type prefix.
    final prefixOrNull = field.library.imports
        .firstWhere((import) {
          return type.library.identifier == import.importedLibrary.identifier;
        }, orElse: () => null)
        ?.prefix
        ?.name;
    final typePrefix =
        (prefixOrNull == null ? '' : '$prefixOrNull.') + '${type.name}';

    final prefix = 'is${usePrefix ? capitalize(field.name) : ''}';

    List<String> generateGetters(FieldElement value) {
      final valueName = value.name;
      final capitalizedValueName = capitalize(valueName);
      return [
        "/// Returns whether this [$className]'s [$fieldName] is [$valueName].",
        'bool get $prefix$capitalizedValueName => $fieldName == $typePrefix.$valueName;',
        if (generateNegations) ...[
          "/// Returns whether this [$className]'s [$fieldName] isn't [$valueName].",
          'bool get ${prefix}Not$capitalizedValueName => $fieldName != $typePrefix.$valueName;',
        ],
      ];
    }

    // Actually generate the extension.
    final buffer = StringBuffer();
    buffer.writeAll([
      '/// `is...` getters for the [$fieldName] field of the [$className].',
      'extension ${className}IsGettersOf${capitalize(fieldName)} on $className {',
      for (final value in enumValues) ...generateGetters(value),
      '}',
    ].expand((line) => [line, '\n']));
    return buffer.toString();
  }
}
