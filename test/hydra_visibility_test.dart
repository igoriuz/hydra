import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';

const _widths = <Breakpoint, double>{
  Breakpoint.mini: 300,
  Breakpoint.small: 700,
  Breakpoint.medium: 1000,
  Breakpoint.large: 1400,
};

/// Returns the breakpoints at which the child of [visibility] is shown.
Future<List<Breakpoint>> _visibleAt(
  WidgetTester tester,
  HydraVisibility visibility,
) async {
  final visible = <Breakpoint>[];
  for (final MapEntry(key: breakpoint, value: width) in _widths.entries) {
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: Size(width, 800)),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: visibility,
        ),
      ),
    );
    if (find.text('child').evaluate().isNotEmpty) visible.add(breakpoint);
  }
  return visible;
}

void main() {
  group('HydraVisibility', () {
    testWidgets('is always visible without bounds', (tester) async {
      expect(
        await _visibleAt(tester, const HydraVisibility(child: Text('child'))),
        Breakpoint.values,
      );
    });

    testWidgets('visibleFrom is an inclusive lower bound', (tester) async {
      expect(
        await _visibleAt(
          tester,
          const HydraVisibility(
            visibleFrom: Breakpoint.medium,
            child: Text('child'),
          ),
        ),
        [Breakpoint.medium, Breakpoint.large],
      );
    });

    testWidgets('visibleUntil is an inclusive upper bound', (tester) async {
      expect(
        await _visibleAt(
          tester,
          const HydraVisibility(
            visibleUntil: Breakpoint.small,
            child: Text('child'),
          ),
        ),
        [Breakpoint.mini, Breakpoint.small],
      );
    });

    testWidgets('combines both bounds', (tester) async {
      expect(
        await _visibleAt(
          tester,
          const HydraVisibility(
            visibleFrom: Breakpoint.small,
            visibleUntil: Breakpoint.medium,
            child: Text('child'),
          ),
        ),
        [Breakpoint.small, Breakpoint.medium],
      );
    });

    testWidgets('is never visible for an empty range', (tester) async {
      expect(
        await _visibleAt(
          tester,
          const HydraVisibility(
            visibleFrom: Breakpoint.large,
            visibleUntil: Breakpoint.mini,
            child: Text('child'),
          ),
        ),
        isEmpty,
      );
    });

    testWidgets('shows the replacement when hidden', (tester) async {
      await _visibleAt(
        tester,
        const HydraVisibility(
          visibleUntil: Breakpoint.medium,
          replacement: Text('replacement'),
          child: Text('child'),
        ),
      );

      // The last pumped width is large, where the child is hidden.
      expect(find.text('replacement'), findsOneWidget);
      expect(find.text('child'), findsNothing);
    });

    testWidgets('builds from a non-const child', (tester) async {
      final label = ['child'].first;

      expect(
        await _visibleAt(
          tester,
          HydraVisibility(visibleUntil: Breakpoint.mini, child: Text(label)),
        ),
        [Breakpoint.mini],
      );
    });

    testWidgets('respects its behaviour', (tester) async {
      expect(
        await _visibleAt(
          tester,
          const HydraVisibility(
            visibleFrom: Breakpoint.large,
            behaviour: HydraBehaviour.bootstrap(),
            child: Text('child'),
          ),
        ),
        [Breakpoint.medium, Breakpoint.large],
      );
    });
  });
}
