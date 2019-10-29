library getters;

/// Generates a `has...` getter indicating whether the annotated field is
/// non-[null].
/// If [generateNegation] is set to [true], also generates a `hasNo...`
/// getter indicating whether the annotated field is [null].
class GenerateHasGetter {
  const GenerateHasGetter({
    this.generateNegation = false,
  }) : assert(generateNegation != null);

  /// Whether `hasNo...` getters should be generated.
  final bool generateNegation;
}

/// Generates `is...` getters indicating whether the annotated enum field is
/// set to the value.
/// If [usePrefix] is set to [true], generates getters instead that have the
/// field name before the value.
/// If [generateNegations] is set to [true], also generates `isNot...` getters
/// indicating whether the annotated enum field is not set to the value.
class GenerateIsGetters {
  const GenerateIsGetters({
    this.usePrefix = false,
    this.generateNegations = false,
  })  : assert(usePrefix != null),
        assert(generateNegations != null);

  /// Whether to use the field name as a prefix to the value.
  final bool usePrefix;

  /// Whether `isNot...` getters should be generated.
  final bool generateNegations;
}
