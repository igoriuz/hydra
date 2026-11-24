/// Exception that was thrown when no widget was provided to a `HydraWidget`.
///
/// No longer thrown: a `HydraWidget` without widgets now fails an assertion,
/// so that it can be `const`.
@Deprecated(
  'No longer thrown; a HydraWidget without widgets fails an assertion. '
  'Will be removed in 3.0.0',
)
class HydraNoWidgetException implements Exception {
  /// Creates a [HydraNoWidgetException] with the given [message].
  @Deprecated(
    'No longer thrown; a HydraWidget without widgets fails an assertion. '
    'Will be removed in 3.0.0',
  )
  const HydraNoWidgetException(this.message);

  /// The error message.
  final String message;

  @override
  String toString() => 'HydraNoWidgetException: $message';
}
