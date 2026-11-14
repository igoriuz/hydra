import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';

Widget _host(double width, HydraTransition? transition) {
  return MediaQuery(
    data: MediaQueryData(size: Size(width, 800)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: HydraWidget(
        transition: transition,
        mini: const Text('mini'),
        large: const Text('large'),
      ),
    ),
  );
}

void main() {
  group('HydraTransition', () {
    testWidgets('swaps instantly without a transition', (tester) async {
      await tester.pumpWidget(_host(300, null));
      await tester.pumpWidget(_host(1400, null));

      expect(find.byType(AnimatedSwitcher), findsNothing);
      expect(find.text('mini'), findsNothing);
      expect(find.text('large'), findsOneWidget);
    });

    testWidgets('fade shows both widgets until it finished', (tester) async {
      const transition = HydraTransition.fade();

      await tester.pumpWidget(_host(300, transition));
      await tester.pumpWidget(_host(1400, transition));
      await tester.pump(const Duration(milliseconds: 150));

      expect(find.text('mini'), findsOneWidget);
      expect(find.text('large'), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text('mini'), findsNothing);
      expect(find.text('large'), findsOneWidget);
    });

    testWidgets('does not animate while the widget stays the same', (
      tester,
    ) async {
      const transition = HydraTransition.fade();

      await tester.pumpWidget(_host(300, transition));
      await tester.pumpWidget(_host(500, transition));

      expect(tester.hasRunningAnimations, isFalse);
      expect(find.text('mini'), findsOneWidget);
    });

    testWidgets('uses the given duration and curve', (tester) async {
      await tester.pumpWidget(
        _host(
          300,
          const HydraTransition.fade(
            duration: Duration(seconds: 1),
            curve: Curves.linear,
          ),
        ),
      );

      final switcher = tester.widget<AnimatedSwitcher>(
        find.byType(AnimatedSwitcher),
      );
      expect(switcher.duration, const Duration(seconds: 1));
      expect(switcher.switchInCurve, Curves.linear);
      expect(switcher.switchOutCurve, Curves.linear);
    });

    testWidgets('scale scales the incoming widget', (tester) async {
      const transition = HydraTransition.scale();

      await tester.pumpWidget(_host(300, transition));
      await tester.pumpWidget(_host(1400, transition));
      await tester.pump(const Duration(milliseconds: 150));

      expect(
        find.ancestor(
          of: find.text('large'),
          matching: find.byType(ScaleTransition),
        ),
        findsOneWidget,
      );

      await tester.pumpAndSettle();
      expect(find.text('mini'), findsNothing);
    });

    test('fade and scale accept a runtime duration', () {
      final duration = Duration(milliseconds: [200].first);

      expect(HydraTransition.fade(duration: duration).duration, duration);
      expect(HydraTransition.scale(duration: duration).duration, duration);
    });

    testWidgets('aligns differently sized widgets as configured', (
      tester,
    ) async {
      const transition = HydraTransition.fade(alignment: Alignment.centerLeft);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(300, 800)),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.topLeft,
              child: HydraWidget(
                transition: transition,
                mini: const SizedBox(key: Key('narrow'), width: 80, height: 50),
                large: const SizedBox(key: Key('wide'), width: 200, height: 50),
              ),
            ),
          ),
        ),
      );
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1400, 800)),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.topLeft,
              child: HydraWidget(
                transition: transition,
                mini: const SizedBox(key: Key('narrow'), width: 80, height: 50),
                large: const SizedBox(key: Key('wide'), width: 200, height: 50),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 150));

      // Both are on screen mid-transition; the narrow one must stay at the
      // left edge instead of being centred over the wide one.
      expect(tester.getTopLeft(find.byKey(const Key('narrow'))).dx, 0);
      expect(tester.getTopLeft(find.byKey(const Key('wide'))).dx, 0);

      await tester.pumpAndSettle();
    });

    for (final axis in Axis.values) {
      testWidgets('size collapses along the $axis axis', (tester) async {
        final transition = HydraTransition.size(axis: axis);

        await tester.pumpWidget(_host(300, transition));
        await tester.pumpWidget(_host(1400, transition));
        await tester.pump(const Duration(milliseconds: 150));

        final sizes = tester.widgetList<SizeTransition>(
          find.byType(SizeTransition),
        );
        expect(sizes, hasLength(2));
        expect(sizes.map((size) => size.axis), everyElement(axis));

        await tester.pumpAndSettle();
        expect(find.text('mini'), findsNothing);
      });
    }

    testWidgets('uses a custom builder', (tester) async {
      final transition = HydraTransition(
        builder: (child, animation) {
          return SizeTransition(sizeFactor: animation, child: child);
        },
      );

      await tester.pumpWidget(_host(300, transition));

      expect(transition.duration, HydraTransition.defaultDuration);
      expect(find.byType(SizeTransition), findsOneWidget);
    });
  });
}
