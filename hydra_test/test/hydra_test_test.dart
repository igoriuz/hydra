import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';
import 'package:hydra_test/hydra_test.dart';

Widget _app() {
  return const Directionality(
    textDirection: TextDirection.ltr,
    child: HydraWidget(
      mini: Text('mini'),
      small: Text('small'),
      medium: Text('medium'),
      large: Text('large'),
    ),
  );
}

void main() {
  group('HydraVariant', () {
    final all = HydraVariant();
    final seen = <Breakpoint>[];

    testWidgets('runs once per breakpoint', variant: all, (tester) async {
      await tester.pumpWidget(_app());

      seen.add(all.currentValue!);
      expect(find.text(all.currentValue!.name), findsOneWidget);
    });

    test('covered every breakpoint in order', () {
      expect(seen, Breakpoint.values);
      expect(all.currentValue, isNull);
    });

    testWidgets('restores the test screen afterwards', (tester) async {
      expect(tester.view.physicalSize, const Size(2400, 1800));
      expect(tester.view.devicePixelRatio, 3);
    });

    final bootstrap = HydraVariant(
      breakpoints: {Breakpoint.mini, Breakpoint.medium},
      behaviour: const HydraBehaviour.bootstrap(),
    );

    testWidgets('uses the given breakpoints and behaviour', variant: bootstrap,
        (tester) async {
      await tester.pumpWidget(
        HydraScope(behaviour: const HydraBehaviour.bootstrap(), child: _app()),
      );

      final width = tester.view.physicalSize.width;
      expect(width, bootstrap.currentValue == Breakpoint.mini ? 360 : 768);
      expect(find.text(bootstrap.currentValue!.name), findsOneWidget);
    });

    final noOrientation = HydraVariant(
      breakpoints: {Breakpoint.large},
      behaviour: const HydraBehaviour.noOrientation(),
    );

    testWidgets('keeps the shortest side wide enough without orientation',
        variant: noOrientation, (tester) async {
      await tester.pumpWidget(
        HydraScope(
          behaviour: const HydraBehaviour.noOrientation(),
          child: _app(),
        ),
      );

      expect(find.text('large'), findsOneWidget);
    });

    test('describes values by name', () {
      expect(all.describeValue(Breakpoint.medium), 'medium');
    });
  });

  group('setBreakpoint', () {
    testWidgets('resizes the test screen to the breakpoint', (tester) async {
      tester.setBreakpoint(Breakpoint.small);
      await tester.pumpWidget(_app());

      expect(find.text('small'), findsOneWidget);
      expect(tester.view.physicalSize, const Size(600, 800));
    });

    testWidgets('mini stays below a small breakpoint under 360', (
      tester,
    ) async {
      const behaviour = HydraBehaviour(breakpointSmall: 320);
      tester.setBreakpoint(Breakpoint.mini, behaviour: behaviour);
      await tester.pumpWidget(
        HydraScope(behaviour: behaviour, child: _app()),
      );

      expect(tester.view.physicalSize.width, 319);
      expect(find.text('mini'), findsOneWidget);
    });

    testWidgets('the screen is reset after the test', (tester) async {
      expect(tester.view.physicalSize, const Size(2400, 1800));
    });
  });
}
