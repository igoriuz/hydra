/// [Breakpoint] is used to distinguish between several device types.
///
/// Comparison between [Breakpoint]s is handled to the getter method `index`.
/// This means:
/// - mini = 0,
/// - small = 1,
/// - medium = 2,
/// - large = 3;
///
/// ```dart
/// Breakpoint.mini.index < Breakpoint.medium.index; // mini = 0, medium = 2
/// ```
enum Breakpoint {
  /// Smallest available breakpoint. By default everything what is smaller than
  /// [Breakpoint.small] is considered as [Breakpoint.mini].
  mini,

  /// Between [Breakpoint.mini] and [Breakpoint.medium].
  small,

  /// Between [Breakpoint.medium] and [Breakpoint.large]
  medium,

  /// Biggest available breakpoint.
  large,
}
