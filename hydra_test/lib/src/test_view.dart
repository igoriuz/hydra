import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';

/// The width a test screen gets for [breakpoint]: the smallest width of that
/// breakpoint, and a phone-like 360 for mini.
double breakpointWidth(Breakpoint breakpoint, HydraBehaviour behaviour) {
  return switch (breakpoint) {
    Breakpoint.mini =>
      behaviour.breakpointSmall > 360 ? 360 : behaviour.breakpointSmall - 1,
    Breakpoint.small => behaviour.breakpointSmall,
    Breakpoint.medium => behaviour.breakpointMedium,
    Breakpoint.large => behaviour.breakpointLarge,
  };
}

/// Resizes [view] in logical pixels so that Hydra resolves [breakpoint].
///
/// Without orientation awareness Hydra reads the shortest side, so the
/// height is raised to at least the width.
void resizeToBreakpoint(
  TestFlutterView view,
  Breakpoint breakpoint, {
  required HydraBehaviour behaviour,
  required double height,
}) {
  final width = breakpointWidth(breakpoint, behaviour);
  final viewHeight =
      behaviour.isOrientationAware ? height : (height < width ? width : height);

  view
    ..devicePixelRatio = 1
    ..physicalSize = Size(width, viewHeight);
}

/// Undoes [resizeToBreakpoint].
void resetView(TestFlutterView view) {
  view
    ..resetPhysicalSize()
    ..resetDevicePixelRatio();
}
