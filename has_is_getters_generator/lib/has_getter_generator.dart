library has_getter_generator;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:has_is_getters/has_is_getters.dart';
import 'package:source_gen/source_gen.dart';

import 'common.dart';

Builder generateHasGetter(BuilderOptions options) =>
    SharedPartBuilder([HasGetterGenerator()], 'has_getter');

class HasGetterGenerator extends GeneratorForAnnotatedField<GenerateHasGetter> {
  @override
  generateForAnnotatedField(FieldElement field, ConstantReader annotation) {
    final bool generateNegation =
        annotation.read('generateNegation').objectValue.toBoolValue();

    final String fieldName = field.name;
    final String className = field.enclosingElement.name;
    assert(fieldName != null);
    assert(className != null);

    // Actually generate the extension.
    final buffer = StringBuffer();
    buffer.writeAll([
      '/// `has...` getters for the [$fieldName] field of the [$className].',
      'extension ${className}HasGetterOf${capitalize(fieldName)} on $className {',
      '/// Returns whether this [$className] contains a non-null [$fieldName] value.',
      'bool get has${capitalize(fieldName)} => $fieldName != null;',
      if (generateNegation) ...[
        '/// Returns whether this [$className] contains a null [$fieldName] value.',
        'bool get hasNo${capitalize(fieldName)} => $fieldName == null;',
      ],
      '}',
    ].expand((line) => [line, '\n']));
    return buffer.toString();
  }
}
