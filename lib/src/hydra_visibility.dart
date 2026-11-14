import 'package:flutter/widgets.dart';
import 'package:hydra/src/breakpoint.dart';
import 'package:hydra/src/hydra_behaviour.dart';
import 'package:hydra/src/hydra_transition.dart';

/// [HydraVisibility] shows its [child] only within a range of breakpoints.
///
/// Both bounds are inclusive and optional. Outside the range the
/// [replacement] is shown and the [child] is not part of the tree - with a
/// [transition], once it finished animating out.
///
/// ```dart
/// HydraVisibility(
///   visibleFrom: Breakpoint.medium,
///   child: SideNavigation(),
/// )
///
/// HydraVisibility(
///   visibleUntil: Breakpoint.small,
///   child: MobileBottomBar(),
/// )
/// ```
class HydraVisibility extends StatelessWidget {
  /// Creates a [HydraVisibility] that shows [child] from [visibleFrom] up to
  /// [visibleUntil].
  const HydraVisibility({
    required this.child,
    this.visibleFrom,
    this.visibleUntil,
    this.replacement = const SizedBox.shrink(),
    this.behaviour,
    this.transition,
    super.key,
  });

  /// The widget to show within the breakpoint range.
  final Widget child;

  /// The smallest breakpoint at which [child] is visible. No lower bound
  /// when `null`.
  final Breakpoint? visibleFrom;

  /// The biggest breakpoint at which [child] is visible. No upper bound
  /// when `null`.
  ///
  /// A value smaller than [visibleFrom] describes an empty range, so the
  /// [child] is never shown.
  final Breakpoint? visibleUntil;

  /// The widget to show outside the breakpoint range.
  final Widget replacement;

  /// {@macro hydra_behaviour}
  ///
  /// When `null`, the behaviour of the nearest `HydraScope` is used.
  final HydraBehaviour? behaviour;

  /// How to animate between [child] and [replacement].
  ///
  /// When `null`, they are swapped instantly.
  final HydraTransition? transition;

  @override
  Widget build(BuildContext context) {
    final current = Breakpoint.current(context, behaviour: behaviour).index;
    final from = visibleFrom?.index ?? Breakpoint.values.first.index;
    final until = visibleUntil?.index ?? Breakpoint.values.last.index;

    final visible = from <= current && current <= until;
    final shown = visible ? child : replacement;

    return transition?.animate(state: visible, child: shown) ?? shown;
  }
}
