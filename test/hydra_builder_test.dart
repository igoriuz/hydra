import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';

Widget _host(Size size, Widget child) {
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

void main() {
  group('HydraBuilder', () {
    testWidgets('passes the active breakpoint to the builder', (tester) async {
      final builder = HydraBuilder(
        builder: (context, breakpoint) => Text(breakpoint.name),
      );

      await tester.pumpWidget(_host(const Size(300, 800), builder));
      expect(find.text('mini'), findsOneWidget);

      await tester.pumpWidget(_host(const Size(1000, 800), builder));
      expect(find.text('medium'), findsOneWidget);
    });

    testWidgets('respects its behaviour', (tester) async {
      await tester.pumpWidget(
        _host(
          const Size(1000, 800),
          HydraBuilder(
            behaviour: const HydraBehaviour.bootstrap(),
            builder: (context, breakpoint) => Text(breakpoint.name),
          ),
        ),
      );

      expect(find.text('large'), findsOneWidget);
    });

    testWidgets('respects the scoped behaviour', (tester) async {
      await tester.pumpWidget(
        _host(
          const Size(1000, 800),
          HydraScope(
            behaviour: const HydraBehaviour.bootstrap(),
            child: HydraBuilder(
              builder: (context, breakpoint) => Text(breakpoint.name),
            ),
          ),
        ),
      );

      expect(find.text('large'), findsOneWidget);
    });
  });
}
