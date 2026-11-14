import 'package:flutter/widgets.dart';
import 'package:hydra/src/hydra_behaviour.dart';
import 'package:hydra/src/hydra_value.dart';

/// Extension on [BuildContext] for convenient responsive value resolution.
extension HydraContext on BuildContext {
  /// Resolves a responsive value based on the current screen breakpoint.
  ///
  /// Without a [behaviour], the one of the nearest `HydraScope` is used.
  ///
  /// ```dart
  /// final padding = context.hydra<double>(mini: 8, large: 32);
  /// ```
  T hydra<T>({
    T? mini,
    T? small,
    T? medium,
    T? large,
    HydraBehaviour? behaviour,
  }) {
    return HydraValue<T>(
      mini: mini,
      small: small,
      medium: medium,
      large: large,
      behaviour: behaviour,
    ).resolve(this);
  }
}
