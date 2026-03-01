/// Exception thrown when no widget was provided to a `HydraWidget`.
class HydraNoWidgetException implements Exception {
  /// Creates a [HydraNoWidgetException] with the given [message].
  const HydraNoWidgetException(this.message);

  /// The error message.
  final String message;

  @override
  String toString() => 'HydraNoWidgetException: $message';
}
