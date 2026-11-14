import 'package:flutter/widgets.dart';

/// [HydraTransition] describes how `HydraWidget` animates from one screen
/// alternative to another when the breakpoint changes.
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
