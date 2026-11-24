import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';

final List<Widget> _children = [for (var i = 0; i < 8; i++) Text('$i')];

Future<SliverGridDelegateWithFixedCrossAxisCount> _delegate(
  WidgetTester tester,
  double width,
  HydraSliverGrid grid,
) async {
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: Size(width, 800)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: CustomScrollView(slivers: [grid]),
      ),
    ),
  );
  return tester.widget<SliverGrid>(find.byType(SliverGrid)).gridDelegate
      as SliverGridDelegateWithFixedCrossAxisCount;
}

void main() {
  group('HydraSliverGrid', () {
    testWidgets('uses the column count of the current breakpoint', (
      tester,
    ) async {
      final grid = HydraSliverGrid(
        mini: 1,
        small: 2,
        medium: 3,
        large: 4,
        children: _children,
      );

      expect((await _delegate(tester, 300, grid)).crossAxisCount, 1);
      expect((await _delegate(tester, 700, grid)).crossAxisCount, 2);
      expect((await _delegate(tester, 1000, grid)).crossAxisCount, 3);
      expect((await _delegate(tester, 1400, grid)).crossAxisCount, 4);
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('falls back to the nearest count and respects behaviour', (
      tester,
    ) async {
      final grid = HydraSliverGrid(
        mini: 1,
        large: 4,
        behaviour: const HydraBehaviour.bootstrap(),
        children: _children,
      );

      expect((await _delegate(tester, 700, grid)).crossAxisCount, 1);
      expect((await _delegate(tester, 1000, grid)).crossAxisCount, 4);
    });

    testWidgets('passes the layout parameters to the delegate', (
      tester,
    ) async {
      final delegate = await _delegate(
        tester,
        300,
        HydraSliverGrid(
          mini: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 8,
          childAspectRatio: 2,
          children: _children,
        ),
      );

      expect(delegate.mainAxisSpacing, 4);
      expect(delegate.crossAxisSpacing, 8);
      expect(delegate.childAspectRatio, 2);
    });

    testWidgets('builder builds only the children that are needed', (
      tester,
    ) async {
      final built = <int>{};
      final grid = HydraSliverGrid.builder(
        mini: 2,
        itemCount: 1000,
        itemBuilder: (context, index) {
          built.add(index);
          return Text('$index');
        },
      );

      expect((await _delegate(tester, 300, grid)).crossAxisCount, 2);
      expect(find.text('0'), findsOneWidget);
      expect(built.length, lessThan(100));
    });

    test('asserts when no column count is given', () {
      expect(
        () => HydraSliverGrid(children: _children),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => HydraSliverGrid.builder(itemBuilder: (context, index) => null),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
