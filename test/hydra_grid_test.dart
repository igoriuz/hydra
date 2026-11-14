import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';

final List<Widget> _children = [for (var i = 0; i < 8; i++) Text('$i')];

Future<int> _columns(WidgetTester tester, double width, HydraGrid grid) async {
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: Size(width, 800)),
      child: Directionality(textDirection: TextDirection.ltr, child: grid),
    ),
  );
  final delegate = tester.widget<GridView>(find.byType(GridView)).gridDelegate;
  return (delegate as SliverGridDelegateWithFixedCrossAxisCount).crossAxisCount;
}

void main() {
  group('HydraGrid', () {
    testWidgets('uses the column count of the current breakpoint', (
      tester,
    ) async {
      final grid = HydraGrid(
        mini: 1,
        small: 2,
        medium: 3,
        large: 4,
        children: _children,
      );

      expect(await _columns(tester, 300, grid), 1);
      expect(await _columns(tester, 700, grid), 2);
      expect(await _columns(tester, 1000, grid), 3);
      expect(await _columns(tester, 1400, grid), 4);
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('falls back to the nearest column count', (tester) async {
      final grid = HydraGrid(mini: 1, large: 4, children: _children);

      expect(await _columns(tester, 700, grid), 1);
      expect(await _columns(tester, 1000, grid), 4);
    });

    testWidgets('respects its behaviour', (tester) async {
      final grid = HydraGrid(
        mini: 1,
        large: 4,
        behaviour: const HydraBehaviour.bootstrap(),
        children: _children,
      );

      expect(await _columns(tester, 1000, grid), 4);
    });

    testWidgets('respects the scoped behaviour', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1000, 800)),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: HydraScope(
              behaviour: const HydraBehaviour.bootstrap(),
              child: HydraGrid(mini: 1, large: 4, children: _children),
            ),
          ),
        ),
      );

      final grid = tester.widget<GridView>(find.byType(GridView));
      expect(
        (grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount)
            .crossAxisCount,
        4,
      );
    });

    testWidgets('passes the layout parameters to the grid', (tester) async {
      await _columns(
        tester,
        300,
        HydraGrid(
          mini: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 8,
          childAspectRatio: 2,
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: _children,
        ),
      );

      final grid = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.mainAxisSpacing, 4);
      expect(delegate.crossAxisSpacing, 8);
      expect(delegate.childAspectRatio, 2);
      expect(grid.padding, const EdgeInsets.all(16));
      expect(grid.shrinkWrap, isTrue);
      expect(grid.physics, isA<NeverScrollableScrollPhysics>());
    });

    test('asserts when no column count is given', () {
      expect(
        () => HydraGrid(children: _children),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
