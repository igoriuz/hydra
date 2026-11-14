import 'package:flutter/widgets.dart';
import 'package:hydra/src/hydra_behaviour.dart';

/// [HydraScope] provides a default [HydraBehaviour] to all Hydra widgets and
/// values below it, so the behaviour is configured once instead of on every
/// usage.
///
/// ```dart
/// HydraScope(
///   behaviour: const HydraBehaviour.material(),
///   child: MaterialApp(...),
/// )
/// ```
///
/// A `behaviour` passed directly to a widget or value always wins over the
/// scoped one.
class HydraScope extends InheritedWidget {
  /// Creates a [HydraScope] that provides [behaviour] to its descendants.
  const HydraScope({
    required this.behaviour,
    required super.child,
    super.key,
  });

  /// The behaviour used by descendants that do not define their own.
  final HydraBehaviour behaviour;

  /// Returns the behaviour of the nearest [HydraScope], or the default
  /// [HydraBehaviour] when there is none.
  static HydraBehaviour of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<HydraScope>()
            ?.behaviour ??
        const HydraBehaviour();
  }

  @override
  bool updateShouldNotify(HydraScope oldWidget) {
    return behaviour != oldWidget.behaviour;
  }
}
