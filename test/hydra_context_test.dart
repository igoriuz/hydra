import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/src/hydra_behaviour.dart';
import 'package:hydra/src/hydra_context.dart';

void main() {
  group('HydraContext', () {
    testWidgets('resolves value at mini breakpoint', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(300, 700)),
          child: Builder(
            builder: (context) {
              final value = context.hydra<String>(
                mini: 'a',
                small: 'b',
                large: 'c',
              );
              return Text(value, textDirection: TextDirection.ltr);
            },
          ),
        ),
      );

      expect(find.text('a'), findsOneWidget);
    });

    testWidgets('resolves value at large breakpoint', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: Builder(
            builder: (context) {
              final value = context.hydra<double>(
                mini: 8,
                large: 32,
              );
              return Text('$value', textDirection: TextDirection.ltr);
            },
          ),
        ),
      );

      expect(find.text('32.0'), findsOneWidget);
    });

    testWidgets('respects custom behaviour', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(kMediumBP, 700)),
          child: Builder(
            builder: (context) {
              final value = context.hydra<String>(
                small: 's',
                large: 'l',
                behaviour: const HydraBehaviour.preferSmaller(),
              );
              return Text(value, textDirection: TextDirection.ltr);
            },
          ),
        ),
      );

      expect(find.text('s'), findsOneWidget);
    });
  });
}
