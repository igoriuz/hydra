/// Exception thrown when no value was provided to a `HydraValue`.
class HydraNoValueException implements Exception {
  /// Creates a [HydraNoValueException] with the given [message].
  const HydraNoValueException(this.message);

  /// The error message.
  final String message;

  @override
  String toString() => 'HydraNoValueException: $message';
}
