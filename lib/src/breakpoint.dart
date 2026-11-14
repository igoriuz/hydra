import 'package:flutter/widgets.dart';
import 'package:hydra/src/hydra_behaviour.dart';
import 'package:hydra/src/hydra_resolver.dart';
import 'package:hydra/src/hydra_scope.dart';

/// [Breakpoint] is used to distinguish between several device types.
///
/// Comparison between [Breakpoint]s is handled to the getter method `index`.
/// This means:
/// - mini = 0,
/// - small = 1,
/// - medium = 2,
/// - large = 3;
///
/// ```dart
/// Breakpoint.mini.index < Breakpoint.medium.index; // mini = 0, medium = 2
/// ```
enum Breakpoint {
  /// Smallest available breakpoint. By default everything what is smaller than
  /// [Breakpoint.small] is considered as [Breakpoint.mini].
  mini,

  /// Between [Breakpoint.mini] and [Breakpoint.medium].
  small,

  /// Between [Breakpoint.medium] and [Breakpoint.large]
  medium,

  /// Biggest available breakpoint.
  large;

  /// Returns the [Breakpoint] that is active for the screen of [context].
  ///
  /// Without a [behaviour], the one of the nearest [HydraScope] is used.
  /// The calling widget rebuilds when the screen size changes.
  ///
  /// ```dart
  /// if (Breakpoint.current(context).index >= Breakpoint.medium.index) {
  ///   showSideNavigation();
  /// }
  /// ```
  static Breakpoint current(BuildContext context, {HydraBehaviour? behaviour}) {
    final resolver = HydraResolver.of(context, behaviour: behaviour);
    return resolver.resolveBreakpoint(resolver.widthOf(context));
  }
}
