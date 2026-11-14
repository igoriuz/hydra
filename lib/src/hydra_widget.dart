import 'package:flutter/material.dart';
import 'package:hydra/src/breakpoint.dart';
import 'package:hydra/src/hydra_behaviour.dart';
import 'package:hydra/src/hydra_head.dart';
import 'package:hydra/src/hydra_no_widget_exception.dart';
import 'package:hydra/src/hydra_resolver.dart';
import 'package:hydra/src/hydra_scope.dart';

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
    Widget? mini,
    Widget? small,
    Widget? medium,
    Widget? large,
  }) : widgets = _buildWidgetList(
          mini: mini,
          small: small,
          medium: medium,
          large: large,
          preferSmaller: behaviour?.isSmallerScreenPreferred ?? false,
        );

  /// {@macro hydra_behaviour}
  ///
  /// When `null`, the behaviour of the nearest [HydraScope] is used.
  final HydraBehaviour? behaviour;

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
    final resolver = HydraResolver(
      behaviour: behaviour ?? HydraScope.of(context),
    );
    final width = resolver.comparableWidth(MediaQuery.sizeOf(context));
    return _nearest(resolver, width).widget;
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
    HydraHead? at(Breakpoint breakpoint) {
      return widgets.where((head) => head.breakpoint == breakpoint).firstOrNull;
    }

    return resolver.resolveValue<HydraHead>(
      comparable,
      mini: at(Breakpoint.mini),
      small: at(Breakpoint.small),
      medium: at(Breakpoint.medium),
      large: at(Breakpoint.large),
    );
  }
}
