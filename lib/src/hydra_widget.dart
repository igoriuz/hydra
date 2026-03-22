import 'package:flutter/material.dart';
import 'package:hydra/src/breakpoint.dart';
import 'package:hydra/src/hydra_behaviour.dart';
import 'package:hydra/src/hydra_head.dart';
import 'package:hydra/src/hydra_no_widget_exception.dart';
import 'package:hydra/src/hydra_resolver.dart';

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
    this.behaviour = const HydraBehaviour(),
    Widget? mini,
    Widget? small,
    Widget? medium,
    Widget? large,
  }) : widgets = _buildWidgetList(
          mini: mini,
          small: small,
          medium: medium,
          large: large,
          preferSmaller: behaviour.isSmallerScreenPreferred,
        );

  /// {@macro hydra_behaviour}
  final HydraBehaviour behaviour;

  /// The resolved list of widget alternatives, ordered by preference.
  final List<HydraHead> widgets;

  static List<HydraHead> _buildWidgetList({
    required Widget? mini,
    required Widget? small,
    required Widget? medium,
    required Widget? large,
    required bool preferSmaller,
  }) {
    final heads = <HydraHead>[
      if (large != null) HydraHead.large(large),
      if (medium != null) HydraHead.medium(medium),
      if (small != null) HydraHead.small(small),
      if (mini != null) HydraHead.mini(mini),
    ];

    if (heads.isEmpty) {
      throw const HydraNoWidgetException('At least one widget is needed');
    }

    return preferSmaller ? heads.reversed.toList() : heads;
  }

  @override
  Widget build(BuildContext context) {
    final width = comparableWidth(MediaQuery.sizeOf(context));
    return nearestWidget(width).widget;
  }

  /// Returns the comparable width based on orientation awareness.
  double comparableWidth(Size size) {
    return HydraResolver(behaviour: behaviour).comparableWidth(size);
  }

  /// Finds the best matching [HydraHead] for the given [comparable] width.
  HydraHead nearestWidget(double comparable) {
    final resolver = HydraResolver(behaviour: behaviour);
    final effectiveBreakpoint = resolver.resolveBreakpoint(comparable);

    return widgets.firstWhere(
      (element) => element.breakpoint == effectiveBreakpoint,
      orElse: () => _closestAlternative(effectiveBreakpoint),
    );
  }

  /// Finds the widget with the shortest distance to [target] breakpoint.
  HydraHead _closestAlternative(Breakpoint target) {
    return widgets.reduce((a, b) {
      final distA = (target.index - a.breakpoint.index).abs();
      final distB = (target.index - b.breakpoint.index).abs();
      // When equidistant, prefer the earlier element in [widgets],
      // which respects the preferSmaller ordering set in [_buildWidgetList].
      return distA <= distB ? a : b;
    });
  }
}
