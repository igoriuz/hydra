import 'package:flutter/material.dart';
import 'hydra_head.dart';
import 'hydra_behaviour.dart';
import 'breakpoint.dart';
import 'hydra_no_widget_exception.dart';

/// [HydraWidget] is a [StatelessWidget] that decides based on the [behaviour] which
/// widget from a list of [widgets] will be shown for the current screen type.
///
/// [behaviour] can be controlled by creating a [HydraBehaviour] object.
///
/// Four screen alternatives [mini], [small], [medium] and [large] are currently
/// supported.
class HydraWidget extends StatelessWidget {
  /// {@macro hydrabehaviour}
  final HydraBehaviour behaviour;

  final List<HydraHead> widgets = [];

  HydraWidget({
    Key key,
    this.behaviour = const HydraBehaviour(),
    Widget mini,
    Widget small,
    Widget medium,
    Widget large,
  }) : super(key: key) {
    var heads = <HydraHead>[];

    if (large != null) {
      heads.add(HydraHead.large(large));
    }
    if (medium != null) {
      heads.add(HydraHead.medium(medium));
    }
    if (small != null) {
      heads.add(HydraHead.small(small));
    }
    if (mini != null) {
      heads.add(HydraHead.mini(mini));
    }

    if (heads.isEmpty) {
      throw HydraNoWidgetException('At least one widget is needed');
    }

    widgets.addAll(behaviour.isSmallerScreenPreferred ? heads.reversed : heads);
  }

  @override
  Widget build(BuildContext context) {
    final width = comparableWidth(MediaQuery.of(context).size);

    return nearestWidget(width).widget;
  }

  double comparableWidth(Size size) {
    return behaviour.isOrientationAware ? size.width : size.shortestSide;
  }

  HydraHead nearestWidget(double comparable) {
    var nearestBreakpoint = Breakpoint.large;

    if (comparable < behaviour.breakpointLarge) {
      nearestBreakpoint = Breakpoint.medium;
    }
    if (comparable < behaviour.breakpointMedium) {
      nearestBreakpoint = Breakpoint.small;
    }
    if (comparable < behaviour.breakpointSmall) {
      nearestBreakpoint = Breakpoint.mini;
    }

    return widgets.firstWhere(
      (element) => (element.breakpoint.index == nearestBreakpoint.index),
      orElse: () => chooseAvailableWidget(nearestBreakpoint),
    );
  }

  HydraHead chooseAvailableWidget(Breakpoint nearestBP) {
    HydraHead nextPossible;
    var distance = Breakpoint.values.length;

    // collect possible alternatives
    var alternatives = <HydraHead>[
      ...widgets.where((element) =>
          (element.breakpoint.index <= nearestBP.index) ||
          (element.breakpoint.index >= nearestBP.index))
    ];

    // choose the widget with shortest distance to nearest breakpoint
    for (var hydraHead in alternatives) {
      var current = (nearestBP.index - hydraHead.breakpoint.index).abs();

      if (current < distance) {
        nextPossible = hydraHead;
        distance = current;
      }
    }

    return nextPossible;
  }
}
