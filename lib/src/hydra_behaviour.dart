import 'package:flutter/foundation.dart';
import 'package:hydra/src/breakpoint.dart';

/// Breakpoint to distinguish the width of the device.
const double kSmallBP = 600;

/// Breakpoint to distinguish the width of the device.
const double kMediumBP = 900;

/// Breakpoint to distinguish the width of the device.
const double kLargeBP = 1200;

/// {@template hydra_behaviour}
/// [HydraBehaviour] defines behaviour for `HydraWidget`.
///
/// In order to decide which device type is used, [HydraBehaviour] exposes
/// [HydraBehaviour.breakpointSmall], [HydraBehaviour.breakpointMedium] and
/// [HydraBehaviour.breakpointLarge].
///
/// [HydraBehaviour.isOrientationAware] defines what should happen when the
/// device is rotated. If it's not aware, then the shortest side is used.
///
/// [HydraBehaviour.isSmallerScreenPreferred] is set to `false` by default,
/// assuming that bigger screens are preferred if there is no screen at the
/// current breakpoint.
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
@immutable
class HydraBehaviour {
  /// {@macro hydra_behaviour}
  const HydraBehaviour({
    this.breakpointSmall = kSmallBP,
    this.breakpointMedium = kMediumBP,
    this.breakpointLarge = kLargeBP,
    this.isOrientationAware = true,
    this.isSmallerScreenPreferred = false,
  })  : assert(
          breakpointSmall < breakpointMedium,
          'breakpointSmall must be less than breakpointMedium',
        ),
        assert(
          breakpointMedium < breakpointLarge,
          'breakpointMedium must be less than breakpointLarge',
        );

  /// Default behaviour except [isSmallerScreenPreferred] is set to `true`.
  const HydraBehaviour.preferSmaller({
    double breakpointSmall = kSmallBP,
    double breakpointMedium = kMediumBP,
    double breakpointLarge = kLargeBP,
    bool isOrientationAware = true,
  }) : this(
          breakpointSmall: breakpointSmall,
          breakpointMedium: breakpointMedium,
          breakpointLarge: breakpointLarge,
          isOrientationAware: isOrientationAware,
          isSmallerScreenPreferred: true,
        );

  /// Default behaviour except that the shortest side will be used. This means
  /// that even when the device is rotated, `HydraWidget` won't choose a
  /// different screen alternative.
  const HydraBehaviour.noOrientation({
    double breakpointSmall = kSmallBP,
    double breakpointMedium = kMediumBP,
    double breakpointLarge = kLargeBP,
    bool isSmallerScreenPreferred = false,
  }) : this(
          breakpointSmall: breakpointSmall,
          breakpointMedium: breakpointMedium,
          breakpointLarge: breakpointLarge,
          isSmallerScreenPreferred: isSmallerScreenPreferred,
          isOrientationAware: false,
        );

  /// Breakpoints based on Material Design layout guidelines.
  ///
  /// - mini: < 600
  /// - small: 600-839
  /// - medium: 840-1199
  /// - large: >= 1200
  ///
  /// See: https://m3.material.io/foundations/layout/applying-layout
  const HydraBehaviour.material({
    bool isOrientationAware = true,
    bool isSmallerScreenPreferred = false,
  }) : this(
          breakpointSmall: 600,
          breakpointMedium: 840,
          breakpointLarge: 1200,
          isOrientationAware: isOrientationAware,
          isSmallerScreenPreferred: isSmallerScreenPreferred,
        );

  /// Breakpoints based on the Bootstrap 5 grid (`sm` / `md` / `lg`).
  ///
  /// - mini: < 576
  /// - small: 576-767
  /// - medium: 768-991
  /// - large: >= 992
  ///
  /// See: https://getbootstrap.com/docs/5.3/layout/breakpoints/
  const HydraBehaviour.bootstrap({
    bool isOrientationAware = true,
    bool isSmallerScreenPreferred = false,
  }) : this(
          breakpointSmall: 576,
          breakpointMedium: 768,
          breakpointLarge: 992,
          isOrientationAware: isOrientationAware,
          isSmallerScreenPreferred: isSmallerScreenPreferred,
        );

  /// Breakpoints based on the Tailwind CSS defaults (`sm` / `md` / `lg`).
  ///
  /// - mini: < 640
  /// - small: 640-767
  /// - medium: 768-1023
  /// - large: >= 1024
  ///
  /// See: https://tailwindcss.com/docs/responsive-design
  const HydraBehaviour.tailwind({
    bool isOrientationAware = true,
    bool isSmallerScreenPreferred = false,
  }) : this(
          breakpointSmall: 640,
          breakpointMedium: 768,
          breakpointLarge: 1024,
          isOrientationAware: isOrientationAware,
          isSmallerScreenPreferred: isSmallerScreenPreferred,
        );

  /// Breakpoints derived from Apple device widths in points.
  ///
  /// Apple publishes no breakpoint system; these values follow common
  /// device widths: 428 (iPhone 12-14 Pro Max in portrait), 768 (iPad in
  /// portrait) and 1024 (iPad in landscape).
  ///
  /// - mini: < 428
  /// - small: 428-767
  /// - medium: 768-1023
  /// - large: >= 1024
  ///
  /// See: https://developer.apple.com/design/human-interface-guidelines/layout
  const HydraBehaviour.cupertino({
    bool isOrientationAware = true,
    bool isSmallerScreenPreferred = false,
  }) : this(
          breakpointSmall: 428,
          breakpointMedium: 768,
          breakpointLarge: 1024,
          isOrientationAware: isOrientationAware,
          isSmallerScreenPreferred: isSmallerScreenPreferred,
        );

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

  @override
  bool operator ==(Object other) {
    return other is HydraBehaviour &&
        other.breakpointSmall == breakpointSmall &&
        other.breakpointMedium == breakpointMedium &&
        other.breakpointLarge == breakpointLarge &&
        other.isOrientationAware == isOrientationAware &&
        other.isSmallerScreenPreferred == isSmallerScreenPreferred;
  }

  @override
  int get hashCode => Object.hash(
        breakpointSmall,
        breakpointMedium,
        breakpointLarge,
        isOrientationAware,
        isSmallerScreenPreferred,
      );
}
