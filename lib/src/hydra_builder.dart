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
///
/// The [builder] only runs again when the breakpoint changes, not on every
/// change of the screen size.
class HydraBuilder extends StatefulWidget {
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
  State<HydraBuilder> createState() => _HydraBuilderState();
}

class _HydraBuilderState extends State<HydraBuilder> {
  Breakpoint? _breakpoint;

  /// Kept as long as breakpoint and widget stay the same: returning the
  /// identical instance lets Flutter skip the subtree while the screen is
  /// resized within a breakpoint.
  Widget? _child;

  @override
  void didUpdateWidget(HydraBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    _child = null;
  }

  @override
  Widget build(BuildContext context) {
    final breakpoint = Breakpoint.current(
      context,
      behaviour: widget.behaviour,
    );
    if (breakpoint != _breakpoint) {
      _breakpoint = breakpoint;
      _child = null;
    }

    // The inner Builder has its own context, so whatever the builder
    // depends on rebuilds it without going through this widget.
    return _child ??= Builder(
      builder: (context) => widget.builder(context, breakpoint),
    );
  }
}
