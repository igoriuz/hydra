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
/// [HydraScope], or a [HydraLayoutScope] to follow the space a part of the
/// screen actually gets.
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

  /// Returns the behaviour of the nearest [HydraScope] or
  /// [HydraLayoutScope], or the default [HydraBehaviour] when there is none.
  static HydraBehaviour of(BuildContext context) {
    return _dataOf(context, _Aspect.behaviour)?.behaviour ??
        const HydraBehaviour();
  }

  /// Returns the breakpoint the nearest [HydraScope] or [HydraLayoutScope]
  /// resolved, or `null` when there is no scope.
  ///
  /// With a [behaviour], only a [HydraLayoutScope] answers: it resolves its
  /// available size with that behaviour. Below a [HydraScope] the result is
  /// `null` then, as the screen size is read from the [MediaQuery].
  static Breakpoint? breakpointOf(
    BuildContext context, {
    HydraBehaviour? behaviour,
  }) {
    if (behaviour == null) {
      return _dataOf(context, _Aspect.breakpoint)?.breakpoint;
    }

    final size = _dataOf(context, _Aspect.layoutSize)?.layoutSize;
    if (size == null) return null;

    final resolver = HydraResolver(behaviour: behaviour);
    return resolver.resolveBreakpoint(resolver.comparableWidth(size));
  }

  static _HydraScopeData? _dataOf(BuildContext context, _Aspect aspect) {
    return InheritedModel.inheritFrom<_HydraScopeData>(
      context,
      aspect: aspect,
    );
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
      layoutSize: null,
      child: child,
    );
  }
}

/// [HydraLayoutScope] resolves the breakpoint from the space its parent
/// gives it instead of the screen size - like a container query in CSS.
///
/// Hydra widgets and values below it adapt to that space, so a list in a
/// side panel or a dialog gets its `mini` layout although the screen is
/// `large`:
///
/// ```dart
/// Row(
///   children: [
///     const SizedBox(width: 360, child: HydraLayoutScope(child: Inbox())),
///     Expanded(child: HydraLayoutScope(child: MessageView())),
///   ],
/// )
/// ```
///
/// Without a [behaviour], the one of the enclosing [HydraScope] is used. A
/// `behaviour` passed directly to a widget below resolves the same available
/// size. Like a [HydraScope], dependents rebuild only when the breakpoint
/// changes.
///
/// The scope needs a bounded width and, being a [LayoutBuilder], cannot be
/// used where intrinsic dimensions are asked for, as in an [IntrinsicHeight].
class HydraLayoutScope extends StatelessWidget {
  /// Creates a [HydraLayoutScope] that resolves the breakpoint from the
  /// space available to [child].
  const HydraLayoutScope({required this.child, this.behaviour, super.key});

  /// The behaviour used by descendants that do not define their own.
  ///
  /// When `null`, the behaviour of the enclosing [HydraScope] is used.
  final HydraBehaviour? behaviour;

  /// The widget below this scope.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final behaviour = this.behaviour ?? HydraScope.of(context);
    final resolver = HydraResolver(behaviour: behaviour);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final width = resolver.comparableWidth(size);
        if (!width.isFinite) {
          throw FlutterError(
            'HydraLayoutScope was given an unbounded width.\n'
            'It resolves the breakpoint from the space its parent gives it, '
            'so it cannot be placed where the width is unbounded, like in a '
            'horizontal list or a Row without an Expanded.',
          );
        }

        return _HydraScopeData(
          behaviour: behaviour,
          breakpoint: resolver.resolveBreakpoint(width),
          layoutSize: size,
          child: child,
        );
      },
    );
  }
}

/// What a dependent of [_HydraScopeData] reads, so that it is only rebuilt
/// when that part changes.
enum _Aspect { behaviour, breakpoint, layoutSize }

class _HydraScopeData extends InheritedModel<_Aspect> {
  const _HydraScopeData({
    required this.behaviour,
    required this.breakpoint,
    required this.layoutSize,
    required super.child,
  });

  final HydraBehaviour behaviour;
  final Breakpoint? breakpoint;

  /// The space of a [HydraLayoutScope]; `null` for a [HydraScope], which
  /// reads the screen size.
  final Size? layoutSize;

  @override
  bool updateShouldNotify(_HydraScopeData oldWidget) {
    return behaviour != oldWidget.behaviour ||
        breakpoint != oldWidget.breakpoint ||
        layoutSize != oldWidget.layoutSize;
  }

  @override
  bool updateShouldNotifyDependent(
    _HydraScopeData oldWidget,
    Set<_Aspect> dependencies,
  ) {
    return (dependencies.contains(_Aspect.behaviour) &&
            behaviour != oldWidget.behaviour) ||
        (dependencies.contains(_Aspect.breakpoint) &&
            breakpoint != oldWidget.breakpoint) ||
        (dependencies.contains(_Aspect.layoutSize) &&
            layoutSize != oldWidget.layoutSize);
  }
}
