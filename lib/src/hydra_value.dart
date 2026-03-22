import 'package:flutter/widgets.dart';
import 'package:hydra/src/hydra_behaviour.dart';
import 'package:hydra/src/hydra_no_value_exception.dart';
import 'package:hydra/src/hydra_resolver.dart';

/// [HydraValue] resolves a value of type [T] based on the current screen
/// breakpoint, using the same logic as `HydraWidget`.
///
/// At least one of [mini], [small], [medium], or [large] must be provided.
///
/// ```dart
/// final padding = HydraValue<double>(mini: 8, small: 16, large: 32);
/// final resolved = padding.resolve(context);
/// ```
class HydraValue<T> {
  /// Creates a [HydraValue] with the given breakpoint values.
  ///
  /// At least one value must be provided.
  HydraValue({
    this.mini,
    this.small,
    this.medium,
    this.large,
    this.behaviour = const HydraBehaviour(),
  }) {
    if (mini == null && small == null && medium == null && large == null) {
      throw const HydraNoValueException('At least one value is needed');
    }
  }

  /// Value for the mini breakpoint.
  final T? mini;

  /// Value for the small breakpoint.
  final T? small;

  /// Value for the medium breakpoint.
  final T? medium;

  /// Value for the large breakpoint.
  final T? large;

  /// The behaviour configuration for breakpoint resolution.
  final HydraBehaviour behaviour;

  /// Resolves the value for the current screen size.
  T resolve(BuildContext context) {
    final resolver = HydraResolver(behaviour: behaviour);
    final width = resolver.comparableWidth(MediaQuery.sizeOf(context));
    return resolver.resolveValue<T>(
      width,
      mini: mini,
      small: small,
      medium: medium,
      large: large,
    );
  }
}
