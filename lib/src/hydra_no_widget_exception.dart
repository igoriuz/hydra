/// Exception thrown when no widget was provided to [HydraWidget].
class HydraNoWidgetException implements Exception {
  /// The error message.
  final String message;

  /// Creates a [HydraNoWidgetException] with the given [message].
  const HydraNoWidgetException(this.message);

  @override
  String toString() => 'HydraNoWidgetException: $message';
}
