import 'package:flutter/widgets.dart';
import 'package:hydra/src/breakpoint.dart';
import 'package:hydra/src/hydra_behaviour.dart';
import 'package:hydra/src/hydra_resolver.dart';

/// [HydraScope] provides a default [HydraBehaviour] to all Hydra widgets and
/// values below it, so the behaviour is configured once instead of on every
/// usage.
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) => HydraScope(
///     behaviour: const HydraBehaviour.material(),
///     child: child!,
///   ),
/// )
/// ```
///
/// A `behaviour` passed directly to a widget or value always wins over the
/// scoped one.
///
/// The scope also resolves the current breakpoint once for everything below
/// it. Hydra widgets and values that share its [MediaQuery] then rebuild
/// only when the breakpoint changes instead of on every change of the
/// screen size. Below another [MediaQuery] - an app widget placed inside
/// the scope creates one - they resolve the breakpoint themselves.
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
  /// when there is no scope or [context] is below a different [MediaQuery]
  /// than the scope.
  static Breakpoint? breakpointOf(BuildContext context) {
    final data = _dataOf(context);
    if (data == null) return null;

    final sharesMediaQuery = identical(data.mediaQuery, _mediaQueryOf(context));
    return sharesMediaQuery ? data.breakpoint : null;
  }

  static _HydraScopeData? _dataOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_HydraScopeData>();
  }

  /// The nearest [MediaQuery], looked up without depending on it.
  static InheritedElement? _mediaQueryOf(BuildContext context) {
    return context.getElementForInheritedWidgetOfExactType<MediaQuery>();
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
      mediaQuery: _mediaQueryOf(context),
      child: child,
    );
  }
}

class _HydraScopeData extends InheritedWidget {
  const _HydraScopeData({
    required this.behaviour,
    required this.breakpoint,
    required this.mediaQuery,
    required super.child,
  });

  final HydraBehaviour behaviour;
  final Breakpoint? breakpoint;
  final InheritedElement? mediaQuery;

  @override
  bool updateShouldNotify(_HydraScopeData oldWidget) {
    return behaviour != oldWidget.behaviour ||
        breakpoint != oldWidget.breakpoint ||
        !identical(mediaQuery, oldWidget.mediaQuery);
  }
}
