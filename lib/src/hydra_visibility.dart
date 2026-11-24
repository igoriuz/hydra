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
    this.maintainState = false,
    super.key,
  }) : assert(
          !maintainState || transition == null,
          'maintainState cannot be combined with a transition',
        );

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

  /// Whether the hidden [child] stays in the tree, keeping its state and
  /// saving the cost of building it again when it becomes visible.
  ///
  /// The hidden child takes no space, is not painted and its animations
  /// are paused. The [replacement] is not shown in this mode, and it
  /// cannot be combined with a [transition].
  final bool maintainState;

  @override
  Widget build(BuildContext context) {
    final current = Breakpoint.current(context, behaviour: behaviour);
    final from = visibleFrom ?? Breakpoint.values.first;
    final until = visibleUntil ?? Breakpoint.values.last;

    final visible = from <= current && current <= until;
    if (maintainState) {
      return Visibility(visible: visible, maintainState: true, child: child);
    }

    final shown = visible ? child : replacement;

    return transition?.animate(state: visible, child: shown) ?? shown;
  }
}
