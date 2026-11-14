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

    test('notifies only when the behaviour differs', () {
      const scope = HydraScope(behaviour: _scoped, child: SizedBox());

      expect(
        scope.updateShouldNotify(
          const HydraScope(
            behaviour: HydraBehaviour(breakpointSmall: 800),
            child: SizedBox(),
          ),
        ),
        isFalse,
      );
      expect(
        scope.updateShouldNotify(
          const HydraScope(behaviour: HydraBehaviour(), child: SizedBox()),
        ),
        isTrue,
      );
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
