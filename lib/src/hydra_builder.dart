import 'package:flutter/widgets.dart';
import 'package:hydra/src/breakpoint.dart';
import 'package:hydra/src/hydra_behaviour.dart';

/// Signature of the callback used by [HydraBuilder].
typedef HydraWidgetBuilder = Widget Function(
  BuildContext context,
  Breakpoint breakpoint,
);

/// [HydraBuilder] builds a single widget tree that adapts to the current
/// [Breakpoint], instead of swapping whole widgets like `HydraWidget`.
///
/// ```dart
/// HydraBuilder(
///   builder: (context, breakpoint) {
///     return Padding(
///       padding: EdgeInsets.all(breakpoint == Breakpoint.mini ? 8 : 24),
///       child: Text('Current: $breakpoint'),
///     );
///   },
/// )
/// ```
class HydraBuilder extends StatelessWidget {
  /// Creates a [HydraBuilder] that calls [builder] with the active
  /// breakpoint.
  const HydraBuilder({required this.builder, this.behaviour, super.key});

  /// Builds the widget for the given breakpoint.
  final HydraWidgetBuilder builder;

  /// {@macro hydra_behaviour}
  ///
  /// When `null`, the behaviour of the nearest `HydraScope` is used.
  final HydraBehaviour? behaviour;

  @override
  Widget build(BuildContext context) {
    return builder(context, Breakpoint.current(context, behaviour: behaviour));
  }
}
