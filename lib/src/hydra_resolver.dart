import 'dart:ui';

import 'package:hydra/src/breakpoint.dart';
import 'package:hydra/src/hydra_behaviour.dart';

/// Shared breakpoint resolution logic used by both `HydraWidget` and
/// `HydraValue`.
class HydraResolver {
  /// Creates a [HydraResolver] with the given [behaviour].
  const HydraResolver({this.behaviour = const HydraBehaviour()});

  /// The behaviour configuration for breakpoint resolution.
  final HydraBehaviour behaviour;

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
  /// [width]. Uses nearest-breakpoint fallback, respecting
  /// `isSmallerScreenPreferred`.
  T resolveValue<T>(
    double width, {
    T? mini,
    T? small,
    T? medium,
    T? large,
  }) {
    final target = resolveBreakpoint(width);

    final entries = <Breakpoint, T>{
      if (mini != null) Breakpoint.mini: mini,
      if (small != null) Breakpoint.small: small,
      if (medium != null) Breakpoint.medium: medium,
      if (large != null) Breakpoint.large: large,
    };

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
