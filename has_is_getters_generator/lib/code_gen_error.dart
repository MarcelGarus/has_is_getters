class CodeGenError extends Error {
  CodeGenError(this.message);

  final String message;

  String toString() => message;
}
