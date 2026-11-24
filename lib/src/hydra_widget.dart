import 'package:flutter/widgets.dart';
import 'package:hydra/src/breakpoint.dart';
import 'package:hydra/src/hydra_behaviour.dart';
import 'package:hydra/src/hydra_head.dart';
import 'package:hydra/src/hydra_resolver.dart';
import 'package:hydra/src/hydra_scope.dart';
import 'package:hydra/src/hydra_transition.dart';

/// [HydraWidget] is a [StatelessWidget] that selects which widget to display
/// based on the current screen size and [behaviour] configuration.
///
/// Up to four screen alternatives are supported: `mini`, `small`, `medium`,
/// and `large`. At least one must be provided.
class HydraWidget extends StatelessWidget {
  /// Creates a [HydraWidget] with the given screen alternatives.
  ///
  /// At least one of [mini], [small], [medium], or [large] must be provided.
  const HydraWidget({
    super.key,
    this.behaviour,
    this.transition,
    this.mini,
    this.small,
    this.medium,
    this.large,
  }) : assert(
          mini != null || small != null || medium != null || large != null,
          'At least one widget is needed',
        );

  /// {@macro hydra_behaviour}
  ///
  /// When `null`, the behaviour of the nearest [HydraScope] is used.
  final HydraBehaviour? behaviour;

  /// How to animate when the breakpoint changes the displayed widget.
  ///
  /// When `null`, the widget is swapped instantly.
  final HydraTransition? transition;

  /// Widget for the mini breakpoint.
  final Widget? mini;

  /// Widget for the small breakpoint.
  final Widget? small;

  /// Widget for the medium breakpoint.
  final Widget? medium;

  /// Widget for the large breakpoint.
  final Widget? large;

  /// The given widget alternatives, biggest breakpoint first - or smallest
  /// first when the local [behaviour] prefers smaller screens.
  @Deprecated(
    'Use mini, small, medium and large. Will be removed in 3.0.0',
  )
  List<HydraHead> get widgets {
    final heads = [
      if (large != null) HydraHead.large(large!),
      if (medium != null) HydraHead.medium(medium!),
      if (small != null) HydraHead.small(small!),
      if (mini != null) HydraHead.mini(mini!),
    ];
    final preferSmaller = behaviour?.isSmallerScreenPreferred ?? false;
    return preferSmaller ? heads.reversed.toList() : heads;
  }

  @override
  Widget build(BuildContext context) {
    final resolver = HydraResolver.of(context, behaviour: behaviour);
    final (breakpoint, widget) = _nearest(
      resolver,
      Breakpoint.current(context, behaviour: behaviour),
    );

    final transition = this.transition;
    if (transition == null) return widget;

    return transition.animate(state: breakpoint, child: widget);
  }

  /// Returns the comparable width based on orientation awareness.
  ///
  /// Uses the local [behaviour] only; a `HydraScope` is not consulted.
  @Deprecated(
    'Ignores HydraScope and HydraLayoutScope; use Breakpoint.current, or '
    'HydraResolver.comparableWidth. Will be removed in 3.0.0',
  )
  double comparableWidth(Size size) => _localResolver.comparableWidth(size);

  /// Finds the best matching [HydraHead] for the given [comparable] width.
  ///
  /// Uses the local [behaviour] only; a `HydraScope` is not consulted.
  @Deprecated(
    'Ignores HydraScope and HydraLayoutScope; use Breakpoint.current, or '
    'HydraResolver.resolveValueAt. Will be removed in 3.0.0',
  )
  HydraHead nearestWidget(double comparable) {
    final resolver = _localResolver;
    final (breakpoint, widget) = _nearest(
      resolver,
      resolver.resolveBreakpoint(comparable),
    );
    return switch (breakpoint) {
      Breakpoint.mini => HydraHead.mini(widget),
      Breakpoint.small => HydraHead.small(widget),
      Breakpoint.medium => HydraHead.medium(widget),
      Breakpoint.large => HydraHead.large(widget),
    };
  }

  HydraResolver get _localResolver {
    return HydraResolver(behaviour: behaviour ?? const HydraBehaviour());
  }

  /// The alternative to show at [breakpoint], with the breakpoint it was
  /// given for.
  (Breakpoint, Widget) _nearest(HydraResolver resolver, Breakpoint breakpoint) {
    (Breakpoint, Widget)? alternative(Breakpoint at, Widget? widget) {
      return widget == null ? null : (at, widget);
    }

    return resolver.resolveValueAt<(Breakpoint, Widget)>(
      breakpoint,
      mini: alternative(Breakpoint.mini, mini),
      small: alternative(Breakpoint.small, small),
      medium: alternative(Breakpoint.medium, medium),
      large: alternative(Breakpoint.large, large),
    );
  }
}
