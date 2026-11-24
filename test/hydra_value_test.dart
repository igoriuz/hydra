import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/src/hydra_behaviour.dart';
import 'package:hydra/src/hydra_value.dart';

void main() {
  group('HydraValue', () {
    test('fails an assertion when no values provided', () {
      expect(
        HydraValue<double>.new,
        throwsA(isA<AssertionError>()),
      );
    });

    test('can be const', () {
      const value = HydraValue<double>(mini: 8);
      expect(identical(value, const HydraValue<double>(mini: 8)), isTrue);
    });

    testWidgets('resolves exact match at mini breakpoint', (tester) async {
      const value = HydraValue<String>(
        mini: 'a',
        small: 'b',
        medium: 'c',
        large: 'd',
      );

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(300, 700)),
          child: Builder(
            builder: (context) {
              final resolved = value.resolve(context);
              return Text(resolved, textDirection: TextDirection.ltr);
            },
          ),
        ),
      );

      expect(find.text('a'), findsOneWidget);
    });

    testWidgets('resolves exact match at large breakpoint', (tester) async {
      const value = HydraValue<String>(
        mini: 'a',
        small: 'b',
        medium: 'c',
        large: 'd',
      );

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: Builder(
            builder: (context) {
              final resolved = value.resolve(context);
              return Text(resolved, textDirection: TextDirection.ltr);
            },
          ),
        ),
      );

      expect(find.text('d'), findsOneWidget);
    });

    testWidgets('falls back to nearest value', (tester) async {
      const value = HydraValue<String>(mini: 'a');

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: Builder(
            builder: (context) {
              final resolved = value.resolve(context);
              return Text(resolved, textDirection: TextDirection.ltr);
            },
          ),
        ),
      );

      expect(find.text('a'), findsOneWidget);
    });

    testWidgets('respects custom behaviour', (tester) async {
      const value = HydraValue<String>(
        small: 's',
        large: 'l',
        behaviour: HydraBehaviour.preferSmaller(),
      );

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(kMediumBP, 700)),
          child: Builder(
            builder: (context) {
              final resolved = value.resolve(context);
              return Text(resolved, textDirection: TextDirection.ltr);
            },
          ),
        ),
      );

      // medium breakpoint, equidistant → prefers smaller
      expect(find.text('s'), findsOneWidget);
    });

    testWidgets('works with non-String types', (tester) async {
      const value = HydraValue<double>(mini: 8, large: 32);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: Builder(
            builder: (context) {
              final resolved = value.resolve(context);
              return Text('$resolved', textDirection: TextDirection.ltr);
            },
          ),
        ),
      );

      expect(find.text('32.0'), findsOneWidget);
    });
  });
}
