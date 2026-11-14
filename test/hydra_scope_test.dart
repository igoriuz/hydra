import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';

// Width 700 is `small` by default (600/900/1200) but `mini` with the
// scoped behaviour below.
const _scoped = HydraBehaviour(breakpointSmall: 800);
const _size = Size(700, 900);

Widget _host(Widget child, {HydraBehaviour? scope}) {
  final content = Directionality(
    textDirection: TextDirection.ltr,
    child: child,
  );
  return MediaQuery(
    data: const MediaQueryData(size: _size),
    child:
        scope == null ? content : HydraScope(behaviour: scope, child: content),
  );
}

void main() {
  group('HydraScope', () {
    testWidgets('of returns the default behaviour without a scope', (
      tester,
    ) async {
      late HydraBehaviour behaviour;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            behaviour = HydraScope.of(context);
            return const SizedBox();
          },
        ),
      );

      expect(behaviour, const HydraBehaviour());
    });

    testWidgets('HydraWidget uses the scoped behaviour', (tester) async {
      await tester.pumpWidget(
        _host(
          HydraWidget(mini: const Text('mini'), small: const Text('small')),
          scope: _scoped,
        ),
      );

      expect(find.text('mini'), findsOneWidget);
    });

    testWidgets('HydraWidget falls back per scoped preference', (tester) async {
      await tester.pumpWidget(
        _host(
          HydraWidget(mini: const Text('mini'), medium: const Text('medium')),
          scope: const HydraBehaviour.preferSmaller(),
        ),
      );

      expect(find.text('mini'), findsOneWidget);
    });

    testWidgets('local behaviour overrides the scoped one', (tester) async {
      await tester.pumpWidget(
        _host(
          HydraWidget(
            behaviour: const HydraBehaviour(),
            mini: const Text('mini'),
            small: const Text('small'),
          ),
          scope: _scoped,
        ),
      );

      expect(find.text('small'), findsOneWidget);
    });

    testWidgets('HydraValue and context.hydra use the scoped behaviour', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          Builder(
            builder: (context) {
              final value = HydraValue<String>(mini: 'a', small: 'b');
              final inline = context.hydra<String>(mini: 'c', small: 'd');
              return Text('${value.resolve(context)}$inline');
            },
          ),
          scope: _scoped,
        ),
      );

      expect(find.text('ac'), findsOneWidget);
    });

    testWidgets('rebuilds dependents when the behaviour changes', (
      tester,
    ) async {
      final widget = HydraWidget(
        mini: const Text('mini'),
        small: const Text('small'),
      );

      await tester.pumpWidget(_host(widget, scope: _scoped));
      expect(find.text('mini'), findsOneWidget);

      await tester.pumpWidget(_host(widget, scope: const HydraBehaviour()));
      expect(find.text('small'), findsOneWidget);
    });

    testWidgets('dependents rebuild only when the breakpoint changes', (
      tester,
    ) async {
      var builds = 0;
      final size = ValueNotifier(const Size(300, 800));
      addTearDown(size.dispose);

      await tester.pumpWidget(
        ValueListenableBuilder(
          valueListenable: size,
          builder: (context, value, child) {
            return MediaQuery(data: MediaQueryData(size: value), child: child!);
          },
          child: HydraScope(
            behaviour: const HydraBehaviour(),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Builder(
                builder: (context) {
                  builds++;
                  final value = context.hydra<String>(mini: 'a', small: 'b');
                  return Text('$value ${Breakpoint.current(context).name}');
                },
              ),
            ),
          ),
        ),
      );
      expect(builds, 1);

      // Still mini: nothing below the scope may rebuild.
      size.value = const Size(500, 800);
      await tester.pump();
      expect(builds, 1);

      size.value = const Size(700, 800);
      await tester.pump();
      expect(builds, 2);
      expect(find.text('b small'), findsOneWidget);
    });

    testWidgets('a nested MediaQuery wins over the breakpoint of the scope', (
      tester,
    ) async {
      await tester.pumpWidget(
        HydraScope(
          behaviour: _scoped,
          child: _host(
            HydraWidget(mini: const Text('mini'), small: const Text('small')),
          ),
        ),
      );

      expect(find.text('mini'), findsOneWidget);
    });
  });

  group('HydraBehaviour equality', () {
    test('equal for the same configuration', () {
      // ignore: prefer_const_constructors, non-const needed for comparison
      final a = HydraBehaviour(breakpointSmall: 500);
      // ignore: prefer_const_constructors, non-const needed for comparison
      final b = HydraBehaviour(breakpointSmall: 500);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(const HydraBehaviour()));
    });
  });
}
