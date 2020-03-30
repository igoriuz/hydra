import 'package:hydra/hydra.dart';

/// Breakpoint to distinguish the width of the device
const double kSmallBP = 90;

/// Breakpoint to distinguish the width of the device
const double kMediumBP = 400;

/// Breakpoint to distinguish the width of the device
const double kLargeBP = 800;

/// {@template hydrabehaviour}
/// [HydraBehaviour] defines behaviour for [HydraWidget].
///
/// In order to decide which device type is used, [HydraBehaviour] exposes
/// [breakpointSmall], [breakpointMedium] and [breakpointLarge].
///
/// [isOrientationAware] defines what should happen when the device is rotated.
/// If it's not aware, then the shortest side is used.
///
/// [isSmallerScreenPreferred] is set to `false` by default, assuming that
/// bigger screens are preferred, if there is no screen at current breakpoint.
///
/// ```dart
/// HydraBehaviour(
///   breakpointSmall: kSmallBP, // mini -> small breakpoint
///   breakpointLarge: kMediumBP, // small -> medium breakpoint
///   breakpointMedium: kLargeBP, // medium -> large breakpoint
///   isOrientationAware: false, // shortest side when device is rotated
///   isSmallerScreenPreferred: true, // prefer smaller screens.
/// )
/// ```
///
/// Default breakpoints are defined in [kSmallBP], [kMediumBP] and [kLargeBP].
/// {@endtemplate}
class HydraBehaviour {
  final double breakpointSmall;
  final double breakpointMedium;
  final double breakpointLarge;
  final bool isOrientationAware;
  final bool isSmallerScreenPreferred;

  /// Default behaviour of [HydraWidget] with [Breakpoint]s derived from
  /// [kSmallBP], [kMediumBP] and [kLargeBP]. Re-evaluates when the devices is
  /// rotated. Also bigger screens are preferred.
  const HydraBehaviour({
    this.breakpointSmall = kSmallBP,
    this.breakpointMedium = kMediumBP,
    this.breakpointLarge = kLargeBP,
    this.isOrientationAware = true,
    this.isSmallerScreenPreferred = false,
  })  : assert(breakpointSmall < breakpointMedium),
        assert(breakpointMedium < breakpointLarge),
        assert(isOrientationAware != null),
        assert(isSmallerScreenPreferred != null);

  /// Default behaviour except that [isSmallerScreenPreferred] is set to `true`.
  /// This means, that [HydraWidget] chooses smaller screens.
  factory HydraBehaviour.preferSmaller() =>
      HydraBehaviour(isSmallerScreenPreferred: true);

  /// Default behaviour except that the shortest side will be used. This means,
  /// that even when the device is rotated, [HydraWidget] won't choose a
  /// different screen alternative.
  factory HydraBehaviour.noOrientation() =>
      HydraBehaviour(isOrientationAware: false);
}
