import 'package:flutter/material.dart';

import 'breakpoint.dart';
import 'hydra_behaviour.dart';
import 'hydra_head.dart';
import 'hydra_no_widget_exception.dart';

/// [HydraWidget] is a [StatelessWidget] that selects which widget to display
/// based on the current screen size and [behaviour] configuration.
///
/// Up to four screen alternatives are supported: [mini], [small], [medium],
/// and [large]. At least one must be provided.
class HydraWidget extends StatelessWidget {
  /// {@macro hydra_behaviour}
  final HydraBehaviour behaviour;

  /// The resolved list of widget alternatives, ordered by preference.
  final List<HydraHead> widgets;

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
      throw HydraNoWidgetException('At least one widget is needed');
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
    return behaviour.isOrientationAware ? size.width : size.shortestSide;
  }

  /// Finds the best matching [HydraHead] for the given [comparable] width.
  HydraHead nearestWidget(double comparable) {
    final effectiveBreakpoint = _breakpointForWidth(comparable);

    return widgets.firstWhere(
      (element) => element.breakpoint == effectiveBreakpoint,
      orElse: () => _closestAlternative(effectiveBreakpoint),
    );
  }

  Breakpoint _breakpointForWidth(double width) {
    if (width < behaviour.breakpointSmall) return Breakpoint.mini;
    if (width < behaviour.breakpointMedium) return Breakpoint.small;
    if (width < behaviour.breakpointLarge) return Breakpoint.medium;
    return Breakpoint.large;
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
