import 'package:flutter/material.dart';

import 'breakpoint.dart';

/// {@template hydra_head}
/// [HydraHead] pairs a [widget] with a [breakpoint] to define which device
/// type the widget is intended for.
/// {@endtemplate}
class HydraHead {
  /// The widget to display for this breakpoint.
  final Widget widget;

  /// The device type breakpoint this head targets.
  final Breakpoint breakpoint;

  const HydraHead._(this.widget, this.breakpoint);

  /// Creates a [HydraHead] targeting [Breakpoint.mini].
  const factory HydraHead.mini(Widget widget) = _MiniHead;

  /// Creates a [HydraHead] targeting [Breakpoint.small].
  const factory HydraHead.small(Widget widget) = _SmallHead;

  /// Creates a [HydraHead] targeting [Breakpoint.medium].
  const factory HydraHead.medium(Widget widget) = _MediumHead;

  /// Creates a [HydraHead] targeting [Breakpoint.large].
  const factory HydraHead.large(Widget widget) = _LargeHead;
}

class _MiniHead extends HydraHead {
  const _MiniHead(Widget widget) : super._(widget, Breakpoint.mini);
}

class _SmallHead extends HydraHead {
  const _SmallHead(Widget widget) : super._(widget, Breakpoint.small);
}

class _MediumHead extends HydraHead {
  const _MediumHead(Widget widget) : super._(widget, Breakpoint.medium);
}

class _LargeHead extends HydraHead {
  const _LargeHead(Widget widget) : super._(widget, Breakpoint.large);
}
