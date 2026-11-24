import 'package:flutter/widgets.dart';
import 'package:hydra/src/breakpoint.dart';
import 'package:hydra/src/hydra_behaviour.dart';
import 'package:hydra/src/hydra_no_value_exception.dart';
import 'package:hydra/src/hydra_resolver.dart';

/// Extension on [BuildContext] for convenient responsive value resolution.
extension HydraContext on BuildContext {
  /// Resolves a responsive value based on the current screen breakpoint.
  ///
  /// Without a [behaviour], the one of the nearest `HydraScope` is used.
  /// Throws a [HydraNoValueException] when no value is given.
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
    return HydraResolver.of(this, behaviour: behaviour).resolveValueAt<T>(
      Breakpoint.current(this, behaviour: behaviour),
      mini: mini,
      small: small,
      medium: medium,
      large: large,
    );
  }
}
