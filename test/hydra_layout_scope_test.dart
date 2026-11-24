import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';

// The screen is large (1400 px); only the box around the scope is narrow.
// The test surface itself is 800 x 600, so boxes stay within that.
Widget _host(Widget child, {double width = 500, double height = 900}) {
  return MediaQuery(
    data: const MediaQueryData(size: Size(1400, 900)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(width: width, height: height, child: child),
      ),
    ),
  );
}

Widget _breakpointText({HydraBehaviour? behaviour}) {
  return Builder(
    builder: (context) {
      return Text(Breakpoint.current(context, behaviour: behaviour).name);
    },
  );
}

void main() {
  group('HydraLayoutScope', () {
    testWidgets('resolves the breakpoint from the available width', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(HydraLayoutScope(child: _breakpointText())),
      );

      expect(find.text('mini'), findsOneWidget);
    });

    testWidgets('Hydra widgets and values below it use that breakpoint', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          HydraLayoutScope(
            child: Column(
              children: [
                const HydraWidget(mini: Text('widget mini'), large: Text('x')),
                Builder(
                  builder: (context) {
                    return Text(context.hydra(mini: 'value mini', large: 'x'));
                  },
                ),
                const HydraVisibility(
                  visibleUntil: Breakpoint.small,
                  child: Text('visible'),
                ),
              ],
            ),
          ),
          width: 700,
        ),
      );

      expect(find.text('widget mini'), findsOneWidget);
      expect(find.text('value mini'), findsOneWidget);
      expect(find.text('visible'), findsOneWidget);
    });

    testWidgets('inherits the behaviour of the enclosing HydraScope', (
      tester,
    ) async {
      late HydraBehaviour behaviour;
      await tester.pumpWidget(
        _host(
          HydraScope(
            behaviour: const HydraBehaviour(breakpointSmall: 400),
            child: HydraLayoutScope(
              child: Builder(
                builder: (context) {
                  behaviour = HydraScope.of(context);
                  return _breakpointText();
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('small'), findsOneWidget);
      expect(behaviour, const HydraBehaviour(breakpointSmall: 400));
    });

    testWidgets('its own behaviour wins over the enclosing one', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          HydraScope(
            behaviour: const HydraBehaviour(breakpointSmall: 400),
            child: HydraLayoutScope(
              behaviour: const HydraBehaviour(),
              child: _breakpointText(),
            ),
          ),
        ),
      );

      expect(find.text('mini'), findsOneWidget);
    });

    testWidgets('a behaviour passed to a widget uses the available width', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          HydraLayoutScope(
            child: _breakpointText(
              behaviour: const HydraBehaviour(breakpointSmall: 400),
            ),
          ),
        ),
      );

      // 500 px with a small breakpoint at 400, not the 1400 px screen.
      expect(find.text('small'), findsOneWidget);
    });

    testWidgets('uses the shortest side without orientation', (tester) async {
      await tester.pumpWidget(
        _host(
          HydraLayoutScope(
            behaviour: const HydraBehaviour.noOrientation(),
            child: _breakpointText(),
          ),
          width: 780,
          height: 500,
        ),
      );

      expect(find.text('mini'), findsOneWidget);
    });

    testWidgets('dependents rebuild only when the breakpoint changes', (
      tester,
    ) async {
      var builds = 0;
      var withBehaviourBuilds = 0;
      final width = ValueNotifier<double>(300);
      addTearDown(width.dispose);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: ValueListenableBuilder<double>(
              valueListenable: width,
              builder: (context, value, child) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(width: value, child: child),
                );
              },
              child: HydraLayoutScope(
                child: Column(
                  children: [
                    Builder(
                      builder: (context) {
                        builds++;
                        return Text(Breakpoint.current(context).name);
                      },
                    ),
                    Builder(
                      builder: (context) {
                        withBehaviourBuilds++;
                        final own = Breakpoint.current(
                          context,
                          behaviour: const HydraBehaviour(),
                        );
                        return Text('own ${own.name}');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      expect(builds, 1);

      // Still mini: the scoped dependent must not rebuild.
      width.value = 500;
      await tester.pump();
      expect(builds, 1);

      width.value = 700;
      await tester.pump();
      expect(builds, 2);
      expect(find.text('small'), findsOneWidget);
      expect(find.text('own small'), findsOneWidget);
      // A widget with its own behaviour follows the width itself.
      expect(withBehaviourBuilds, 3);
    });

    testWidgets('an inner HydraLayoutScope sees its own width', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          HydraLayoutScope(
            child: Row(
              children: [
                SizedBox(width: 300, child: _breakpointText()),
                SizedBox(
                  width: 450,
                  child: HydraLayoutScope(child: _breakpointText()),
                ),
              ],
            ),
          ),
          width: 780,
        ),
      );

      // The outer scope is small (780 px), the inner one mini (450 px).
      expect(find.text('small'), findsOneWidget);
      expect(find.text('mini'), findsOneWidget);
    });

    testWidgets('throws without a bounded width', (tester) async {
      // The default error widget cannot lay out in an unbounded width
      // either, which would report a second error.
      final errorWidgetBuilder = ErrorWidget.builder;
      ErrorWidget.builder = (_) => const SizedBox.shrink();
      addTearDown(() => ErrorWidget.builder = errorWidgetBuilder);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: UnconstrainedBox(
              child: HydraLayoutScope(child: _breakpointText()),
            ),
          ),
        ),
      );

      expect(
        tester.takeException(),
        isA<FlutterError>().having(
          (e) => e.message,
          'message',
          contains('unbounded width'),
        ),
      );
    });
  });
}
