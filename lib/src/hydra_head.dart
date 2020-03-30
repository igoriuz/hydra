import 'package:flutter/material.dart';
import 'package:hydra/hydra.dart';

import 'breakpoint.dart';

/// {@template hydrahead}
/// [HydraHead] exposes [breakpoint] to define for which kind of device type
/// it is used to build a widget by its [widget].
/// {@endtemplate}
class HydraHead {
  /// build method for the widget which should be built.
  final Widget widget;

  /// Describes for which kind of device type it should be used.
  final Breakpoint breakpoint;

  /// Not exposed for public. Only accessible by the following factories:
  ///
  /// ```dart
  ///  HydraHead.mini(WIDGET_FUNCTION);
  /// ```
  ///
  /// ```dart
  ///  HydraHead.small(WIDGET_FUNCTION);
  /// ```
  ///
  /// ```dart
  ///  HydraHead.medium(WIDGET_FUNCTION);
  /// ```
  ///
  /// ```dart
  ///  HydraHead.large(WIDGET_FUNCTION);
  /// ```
  HydraHead._(this.widget, this.breakpoint);

  /// [HydraHead] exposes [widgetBehaviour] for defining the build method.
  /// Uses private constructor with [Breakpoint.mini].
  factory HydraHead.mini(Widget widgetBehaviour) =>
      HydraHead._(widgetBehaviour, Breakpoint.mini);

  /// [HydraHead] exposes [widgetBehaviour] for defining the build method.
  /// Uses private constructor with [Breakpoint.small].
  factory HydraHead.small(Widget widgetBehaviour) =>
      HydraHead._(widgetBehaviour, Breakpoint.small);

  /// [HydraHead] exposes [widgetBehaviour] for defining the build method.
  /// Uses private constructor with [Breakpoint.medium].
  factory HydraHead.medium(Widget widgetBehaviour) =>
      HydraHead._(widgetBehaviour, Breakpoint.medium);

  /// [HydraHead] exposes [widgetBehaviour] for defining the build method.
  /// Uses private constructor with [Breakpoint.large].
  factory HydraHead.large(Widget widgetBehaviour) =>
      HydraHead._(widgetBehaviour, Breakpoint.large);
}
