import 'package:flutter/widgets.dart';
import 'package:hydra/src/breakpoint.dart';
import 'package:hydra/src/hydra_behaviour.dart';
import 'package:hydra/src/hydra_no_value_exception.dart';
import 'package:hydra/src/hydra_scope.dart';

/// Shared breakpoint resolution logic used by both `HydraWidget` and
/// `HydraValue`.
class HydraResolver {
  /// Creates a [HydraResolver] with the given [behaviour].
  const HydraResolver({this.behaviour = const HydraBehaviour()});

  /// Creates a [HydraResolver] for [context]: with [behaviour] when given,
  /// otherwise with the behaviour of the nearest [HydraScope].
  factory HydraResolver.of(BuildContext context, {HydraBehaviour? behaviour}) {
    return HydraResolver(behaviour: behaviour ?? HydraScope.of(context));
  }

  /// The behaviour configuration for breakpoint resolution.
  final HydraBehaviour behaviour;

  /// Returns the [comparableWidth] of the screen of [context].
  double widthOf(BuildContext context) {
    return comparableWidth(MediaQuery.sizeOf(context));
  }

  /// Returns `size.width` when orientation-aware, or `size.shortestSide`
  /// when not.
  double comparableWidth(Size size) {
    return behaviour.isOrientationAware ? size.width : size.shortestSide;
  }

  /// Maps a screen width to a [Breakpoint] enum value.
  Breakpoint resolveBreakpoint(double width) {
    if (width < behaviour.breakpointSmall) return Breakpoint.mini;
    if (width < behaviour.breakpointMedium) return Breakpoint.small;
    if (width < behaviour.breakpointLarge) return Breakpoint.medium;
    return Breakpoint.large;
  }

  /// Resolves the best value from four nullable candidates for the given
  /// [width]. See [resolveValueAt].
  T resolveValue<T>(
    double width, {
    T? mini,
    T? small,
    T? medium,
    T? large,
  }) {
    return resolveValueAt<T>(
      resolveBreakpoint(width),
      mini: mini,
      small: small,
      medium: medium,
      large: large,
    );
  }

  /// Resolves the best value from four nullable candidates for the
  /// [target] breakpoint. Uses nearest-breakpoint fallback, respecting
  /// `isSmallerScreenPreferred`.
  ///
  /// Throws a [HydraNoValueException] when all candidates are `null`.
  T resolveValueAt<T>(
    Breakpoint target, {
    T? mini,
    T? small,
    T? medium,
    T? large,
  }) {
    final entries = <Breakpoint, T>{
      if (mini != null) Breakpoint.mini: mini,
      if (small != null) Breakpoint.small: small,
      if (medium != null) Breakpoint.medium: medium,
      if (large != null) Breakpoint.large: large,
    };

    if (entries.isEmpty) {
      throw const HydraNoValueException('At least one value is needed');
    }
    if (entries.containsKey(target)) return entries[target] as T;

    // Build candidate list ordered by preference
    final candidates = entries.entries.toList();
    if (behaviour.isSmallerScreenPreferred) {
      candidates.sort((a, b) => a.key.index.compareTo(b.key.index));
    } else {
      candidates.sort((a, b) => b.key.index.compareTo(a.key.index));
    }

    return candidates.reduce((a, b) {
      final distA = (target.index - a.key.index).abs();
      final distB = (target.index - b.key.index).abs();
      return distA <= distB ? a : b;
    }).value;
  }
}
