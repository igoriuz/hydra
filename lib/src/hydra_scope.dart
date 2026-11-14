import 'package:flutter/widgets.dart';
import 'package:hydra/src/breakpoint.dart';
import 'package:hydra/src/hydra_behaviour.dart';
import 'package:hydra/src/hydra_resolver.dart';

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
///
/// The scope also resolves the current breakpoint once, from the screen
/// size at its own place in the tree. Hydra widgets and values below it
/// then rebuild only when the breakpoint changes instead of on every
/// change of the screen size.
///
/// A [MediaQuery] with a different size below the scope - a preview frame
/// or a split view - is not seen by it. Give that subtree its own
/// [HydraScope].
class HydraScope extends StatelessWidget {
  /// Creates a [HydraScope] that provides [behaviour] to its descendants.
  const HydraScope({
    required this.behaviour,
    required this.child,
    super.key,
  });

  /// The behaviour used by descendants that do not define their own.
  final HydraBehaviour behaviour;

  /// The widget below this scope.
  final Widget child;

  /// Returns the behaviour of the nearest [HydraScope], or the default
  /// [HydraBehaviour] when there is none.
  static HydraBehaviour of(BuildContext context) {
    return _dataOf(context)?.behaviour ?? const HydraBehaviour();
  }

  /// Returns the breakpoint the nearest [HydraScope] resolved, or `null`
  /// when there is no scope.
  static Breakpoint? breakpointOf(BuildContext context) {
    return _dataOf(context)?.breakpoint;
  }

  static _HydraScopeData? _dataOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_HydraScopeData>();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.maybeSizeOf(context);
    final resolver = HydraResolver(behaviour: behaviour);

    return _HydraScopeData(
      behaviour: behaviour,
      breakpoint: size == null
          ? null
          : resolver.resolveBreakpoint(resolver.comparableWidth(size)),
      child: child,
    );
  }
}

class _HydraScopeData extends InheritedWidget {
  const _HydraScopeData({
    required this.behaviour,
    required this.breakpoint,
    required super.child,
  });

  final HydraBehaviour behaviour;
  final Breakpoint? breakpoint;

  @override
  bool updateShouldNotify(_HydraScopeData oldWidget) {
    return behaviour != oldWidget.behaviour ||
        breakpoint != oldWidget.breakpoint;
  }
}
