import 'package:flutter/material.dart';
import 'package:hydra/src/hydra_behaviour.dart';
import 'package:hydra/src/hydra_head.dart';
import 'package:hydra/src/hydra_no_widget_exception.dart';
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
  HydraWidget({
    super.key,
    this.behaviour,
    this.transition,
    this.mini,
    this.small,
    this.medium,
    this.large,
  }) {
    if (mini == null && small == null && medium == null && large == null) {
      throw const HydraNoWidgetException('At least one widget is needed');
    }
  }

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
  List<HydraHead> get widgets {
    final heads = [_large, _medium, _small, _mini].nonNulls.toList();
    final preferSmaller = behaviour?.isSmallerScreenPreferred ?? false;
    return preferSmaller ? heads.reversed.toList() : heads;
  }

  HydraHead? get _mini => mini == null ? null : HydraHead.mini(mini!);
  HydraHead? get _small => small == null ? null : HydraHead.small(small!);
  HydraHead? get _medium => medium == null ? null : HydraHead.medium(medium!);
  HydraHead? get _large => large == null ? null : HydraHead.large(large!);

  @override
  Widget build(BuildContext context) {
    final resolver = HydraResolver.of(context, behaviour: behaviour);
    final head = _nearest(resolver, resolver.widthOf(context));

    final transition = this.transition;
    if (transition == null) return head.widget;

    return AnimatedSwitcher(
      duration: transition.duration,
      switchInCurve: transition.curve,
      switchOutCurve: transition.curve,
      transitionBuilder: transition.builder,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: transition.alignment,
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: KeyedSubtree(
        key: ValueKey(head.breakpoint),
        child: head.widget,
      ),
    );
  }

  /// Returns the comparable width based on orientation awareness.
  ///
  /// Uses the local [behaviour] only; a `HydraScope` is not consulted.
  double comparableWidth(Size size) => _localResolver.comparableWidth(size);

  /// Finds the best matching [HydraHead] for the given [comparable] width.
  ///
  /// Uses the local [behaviour] only; a `HydraScope` is not consulted.
  HydraHead nearestWidget(double comparable) {
    return _nearest(_localResolver, comparable);
  }

  HydraResolver get _localResolver {
    return HydraResolver(behaviour: behaviour ?? const HydraBehaviour());
  }

  HydraHead _nearest(HydraResolver resolver, double comparable) {
    return resolver.resolveValue<HydraHead>(
      comparable,
      mini: _mini,
      small: _small,
      medium: _medium,
      large: _large,
    );
  }
}
