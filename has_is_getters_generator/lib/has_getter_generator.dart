library has_getter_generator;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:has_is_getters/has_is_getters.dart';
import 'package:source_gen/source_gen.dart';

import 'code_gen_error.dart';

Builder generateHasGetter(BuilderOptions options) =>
    SharedPartBuilder([HasGetterGenerator()], 'has_getter');

class HasGetterGenerator extends GeneratorForAnnotation<GenerateHasGetter> {
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, _) {
    final bool generateNegation =
        annotation.read('generateNegation').objectValue.toBoolValue();

    if (element is! FieldElement) {
      throw CodeGenError('You can only annotate fields.');
    }

    final FieldElement field = element;
    final String fieldName = field.name;
    final String className = field.enclosingElement.name;
    assert(fieldName != null);
    assert(className != null);

    if (field.getter == null) {
      throw CodeGenError('The field must have a getter.');
    }

    // Actually generate the extension.
    final buffer = StringBuffer();
    buffer.writeAll([
      'extension $className${fieldName}HasGetter on $className {',
      'bool get has$fieldName => $fieldName != null;',
      if (generateNegation) 'bool get hasNo$fieldName => $fieldName == null;',
      '}',
    ].expand((line) => [line, '\n']));
    return buffer.toString();
  }
}
