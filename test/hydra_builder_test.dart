import 'package:flutter/widgets.dart';
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

    testWidgets('calls the builder only when the breakpoint changes', (
      tester,
    ) async {
      var builds = 0;
      final size = ValueNotifier(const Size(300, 800));
      addTearDown(size.dispose);

      await tester.pumpWidget(
        ValueListenableBuilder(
          valueListenable: size,
          builder: (context, value, child) {
            return MediaQuery(data: MediaQueryData(size: value), child: child!);
          },
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: HydraBuilder(
              builder: (context, breakpoint) {
                builds++;
                return Text(breakpoint.name);
              },
            ),
          ),
        ),
      );
      expect(builds, 1);

      // Still mini: resizing within a breakpoint must not rebuild.
      size.value = const Size(500, 800);
      await tester.pump();
      expect(builds, 1);

      size.value = const Size(700, 800);
      await tester.pump();
      expect(builds, 2);
      expect(find.text('small'), findsOneWidget);
    });

    testWidgets('rebuilds when something the builder depends on changes', (
      tester,
    ) async {
      final direction = ValueNotifier(TextDirection.ltr);
      addTearDown(direction.dispose);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(300, 800)),
          child: ValueListenableBuilder(
            valueListenable: direction,
            builder: (context, value, child) {
              return Directionality(textDirection: value, child: child!);
            },
            child: HydraBuilder(
              builder: (context, breakpoint) {
                return Text(Directionality.of(context).name);
              },
            ),
          ),
        ),
      );
      expect(find.text('ltr'), findsOneWidget);

      direction.value = TextDirection.rtl;
      await tester.pump();
      expect(find.text('rtl'), findsOneWidget);
    });

    testWidgets('uses a new builder when the parent rebuilds', (tester) async {
      Widget host(String label) {
        return _host(
          const Size(300, 800),
          HydraBuilder(builder: (context, breakpoint) => Text(label)),
        );
      }

      await tester.pumpWidget(host('first'));
      await tester.pumpWidget(host('second'));

      expect(find.text('second'), findsOneWidget);
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
