import 'package:has_is_getters/has_is_getters.dart';
import 'package:test/test.dart';

void main() {
  group('existence annotation tests', () {});
  group('value getters annotation tests', () {
    test('no required values', () {
      GenerateIsGetters();
    });
    test('default values are to generate as little as possible', () {
      final annotation = GenerateIsGetters();
      expect(annotation.usePrefix, false);
      expect(annotation.generateNegations, false);
    });
    test('values get actually saved', () {
      final annotation = GenerateIsGetters(
        usePrefix: true,
        generateNegations: true,
      );
      expect(annotation.usePrefix, true);
      expect(annotation.generateNegations, true);
    });
  });
}
