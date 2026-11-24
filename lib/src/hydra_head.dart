// The private subclasses use the deprecated constructor of their own class.
// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/widgets.dart';

import 'package:hydra/src/breakpoint.dart';

/// {@template hydra_head}
/// [HydraHead] pairs a [widget] with a [breakpoint] to define which device
/// type the widget is intended for.
/// {@endtemplate}
@Deprecated(
  'Only used by HydraWidget.widgets and nearestWidget, which are deprecated. '
  'Will be removed in 3.0.0',
)
class HydraHead {
  /// {@macro hydra_head}
  @Deprecated('Will be removed in 3.0.0, together with HydraHead')
  const HydraHead._(this.widget, this.breakpoint);

  /// Creates a [HydraHead] targeting [Breakpoint.mini].
  @Deprecated('Will be removed in 3.0.0, together with HydraHead')
  const factory HydraHead.mini(Widget widget) = _MiniHead;

  /// Creates a [HydraHead] targeting [Breakpoint.small].
  @Deprecated('Will be removed in 3.0.0, together with HydraHead')
  const factory HydraHead.small(Widget widget) = _SmallHead;

  /// Creates a [HydraHead] targeting [Breakpoint.medium].
  @Deprecated('Will be removed in 3.0.0, together with HydraHead')
  const factory HydraHead.medium(Widget widget) = _MediumHead;

  /// Creates a [HydraHead] targeting [Breakpoint.large].
  @Deprecated('Will be removed in 3.0.0, together with HydraHead')
  const factory HydraHead.large(Widget widget) = _LargeHead;

  /// The widget to display for this breakpoint.
  final Widget widget;

  /// The device type breakpoint this head targets.
  final Breakpoint breakpoint;
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
