import 'package:hydra/hydra.dart';

/// [Exception] when no [Widget] was given to [HydraWidget].
class HydraNoWidgetException implements Exception {
  /// The error message.
  String message;

  /// Default constructor for this error.
  HydraNoWidgetException(this.message);
}
