import 'package:hydra/src/breakpoint.dart';

/// Breakpoint to distinguish the width of the device.
const double kSmallBP = 600;

/// Breakpoint to distinguish the width of the device.
const double kMediumBP = 900;

/// Breakpoint to distinguish the width of the device.
const double kLargeBP = 1200;

/// {@template hydra_behaviour}
/// [HydraBehaviour] defines behaviour for [HydraWidget].
///
/// In order to decide which device type is used, [HydraBehaviour] exposes
/// [breakpointSmall], [breakpointMedium] and [breakpointLarge].
///
/// [isOrientationAware] defines what should happen when the device is rotated.
/// If it's not aware, then the shortest side is used.
///
/// [isSmallerScreenPreferred] is set to `false` by default, assuming that
/// bigger screens are preferred if there is no screen at the current breakpoint.
///
/// ```dart
/// HydraBehaviour(
///   breakpointSmall: kSmallBP,
///   breakpointMedium: kMediumBP,
///   breakpointLarge: kLargeBP,
///   isOrientationAware: false,
///   isSmallerScreenPreferred: true,
/// )
/// ```
///
/// Default breakpoints are defined in [kSmallBP], [kMediumBP] and [kLargeBP].
/// {@endtemplate}
class HydraBehaviour {
  /// Breakpoint threshold between [Breakpoint.mini] and [Breakpoint.small].
  final double breakpointSmall;

  /// Breakpoint threshold between [Breakpoint.small] and [Breakpoint.medium].
  final double breakpointMedium;

  /// Breakpoint threshold between [Breakpoint.medium] and [Breakpoint.large].
  final double breakpointLarge;

  /// Whether the widget should re-evaluate when device orientation changes.
  final bool isOrientationAware;

  /// Whether to prefer smaller screen alternatives when no exact match exists.
  final bool isSmallerScreenPreferred;

  /// {@macro hydra_behaviour}
  const HydraBehaviour({
    this.breakpointSmall = kSmallBP,
    this.breakpointMedium = kMediumBP,
    this.breakpointLarge = kLargeBP,
    this.isOrientationAware = true,
    this.isSmallerScreenPreferred = false,
  })  : assert(breakpointSmall < breakpointMedium),
        assert(breakpointMedium < breakpointLarge);

  /// Default behaviour except that [isSmallerScreenPreferred] is set to `true`.
  const HydraBehaviour.preferSmaller({
    this.breakpointSmall = kSmallBP,
    this.breakpointMedium = kMediumBP,
    this.breakpointLarge = kLargeBP,
    this.isOrientationAware = true,
  })  : isSmallerScreenPreferred = true,
        assert(breakpointSmall < breakpointMedium),
        assert(breakpointMedium < breakpointLarge);

  /// Default behaviour except that the shortest side will be used. This means
  /// that even when the device is rotated, [HydraWidget] won't choose a
  /// different screen alternative.
  const HydraBehaviour.noOrientation({
    this.breakpointSmall = kSmallBP,
    this.breakpointMedium = kMediumBP,
    this.breakpointLarge = kLargeBP,
    this.isSmallerScreenPreferred = false,
  })  : isOrientationAware = false,
        assert(breakpointSmall < breakpointMedium),
        assert(breakpointMedium < breakpointLarge);

  /// Breakpoints based on Material Design layout guidelines.
  ///
  /// - mini: < 600
  /// - small: 600–839
  /// - medium: 840–1199
  /// - large: >= 1200
  ///
  /// See: https://m3.material.io/foundations/layout/applying-layout
  const HydraBehaviour.material({
    this.isOrientationAware = true,
    this.isSmallerScreenPreferred = false,
  })  : breakpointSmall = 600,
        breakpointMedium = 840,
        breakpointLarge = 1200;
}
