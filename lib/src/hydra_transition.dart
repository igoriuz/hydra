import 'package:flutter/widgets.dart';

/// [HydraTransition] describes how `HydraWidget` and `HydraVisibility`
/// animate from one widget to another when the breakpoint changes.
///
/// ```dart
/// HydraWidget(
///   transition: const HydraTransition.fade(),
///   mini: mobileLayout(),
///   large: desktopLayout(),
/// )
/// ```
@immutable
class HydraTransition {
  /// Creates a transition that animates with a custom [builder].
  const HydraTransition({
    required this.builder,
    this.duration = defaultDuration,
    this.curve = Curves.easeInOut,
    this.alignment = Alignment.center,
  });

  /// Cross-fades between the old and the new widget.
  const HydraTransition.fade({
    this.duration = defaultDuration,
    this.curve = Curves.easeInOut,
    this.alignment = Alignment.center,
  }) : builder = AnimatedSwitcher.defaultTransitionBuilder;

  /// Fades and scales the new widget in while the old one fades out.
  const HydraTransition.scale({
    this.duration = defaultDuration,
    this.curve = Curves.easeInOut,
    this.alignment = Alignment.center,
  }) : builder = _scale;

  /// Collapses the outgoing widget along [axis] while the incoming one
  /// expands, so the surrounding layout makes room gradually. Suited to
  /// widgets that appear and disappear, like a side navigation.
  const HydraTransition.size({
    Axis axis = Axis.horizontal,
    this.duration = defaultDuration,
    this.curve = Curves.easeInOut,
    this.alignment = Alignment.center,
  }) : builder = axis == Axis.horizontal ? _sizeHorizontal : _sizeVertical;

  /// The duration used when none is given.
  static const Duration defaultDuration = Duration(milliseconds: 300);

  /// How long the transition takes.
  final Duration duration;

  /// The curve applied to the incoming and the outgoing widget.
  final Curve curve;

  /// How the incoming and the outgoing widget are aligned while both are
  /// visible. Matters when they differ in size, e.g. `Alignment.centerLeft`
  /// for a side navigation that grows to the right.
  final AlignmentGeometry alignment;

  /// Wraps the incoming and the outgoing widget in an animated widget.
  final AnimatedSwitcherTransitionBuilder builder;

  /// Builds the widget that animates from the previously shown [child] to
  /// the given one. A new [state] starts the transition; rebuilding with
  /// the same [state] only updates the [child].
  Widget animate({required Object state, required Widget child}) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: curve,
      transitionBuilder: builder,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: alignment,
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: KeyedSubtree(key: ValueKey(state), child: child),
    );
  }

  static Widget _sizeHorizontal(Widget child, Animation<double> animation) {
    return SizeTransition(
      axis: Axis.horizontal,
      sizeFactor: animation,
      child: child,
    );
  }

  static Widget _sizeVertical(Widget child, Animation<double> animation) {
    return SizeTransition(sizeFactor: animation, child: child);
  }

  static Widget _scale(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.92, end: 1).animate(animation),
        child: child,
      ),
    );
  }
}
