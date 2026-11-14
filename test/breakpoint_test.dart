import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';

Future<Breakpoint> _current(
  WidgetTester tester,
  Size size, {
  HydraBehaviour? behaviour,
  HydraBehaviour? scope,
}) async {
  late Breakpoint breakpoint;
  final builder = Builder(
    builder: (context) {
      breakpoint = Breakpoint.current(context, behaviour: behaviour);
      return const SizedBox();
    },
  );
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: size),
      child: scope == null
          ? builder
          : HydraScope(behaviour: scope, child: builder),
    ),
  );
  return breakpoint;
}

void main() {
  group('Breakpoint.current', () {
    testWidgets('resolves every breakpoint with the default behaviour', (
      tester,
    ) async {
      expect(await _current(tester, const Size(599, 800)), Breakpoint.mini);
      expect(await _current(tester, const Size(600, 800)), Breakpoint.small);
      expect(await _current(tester, const Size(900, 800)), Breakpoint.medium);
      expect(await _current(tester, const Size(1200, 800)), Breakpoint.large);
    });

    testWidgets('uses the given behaviour', (tester) async {
      expect(
        await _current(
          tester,
          const Size(1300, 500),
          behaviour: const HydraBehaviour.noOrientation(),
        ),
        Breakpoint.mini,
      );
    });

    testWidgets('uses the scoped behaviour', (tester) async {
      expect(
        await _current(
          tester,
          const Size(700, 800),
          scope: const HydraBehaviour(breakpointSmall: 800),
        ),
        Breakpoint.mini,
      );
    });

    testWidgets('given behaviour overrides the scoped one', (tester) async {
      expect(
        await _current(
          tester,
          const Size(700, 800),
          behaviour: const HydraBehaviour(),
          scope: const HydraBehaviour(breakpointSmall: 800),
        ),
        Breakpoint.small,
      );
    });
  });
}
