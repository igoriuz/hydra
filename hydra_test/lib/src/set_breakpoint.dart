import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';
import 'package:hydra_test/src/test_view.dart';

/// Sets the test screen to a breakpoint for a single test.
extension HydraWidgetTester on WidgetTester {
  /// Resizes the test screen so that Hydra resolves [breakpoint], until the
  /// test ends.
  ///
  /// ```dart
  /// testWidgets('shows a bottom bar on phones', (tester) async {
  ///   tester.setBreakpoint(Breakpoint.mini);
  ///   await tester.pumpWidget(const MyApp());
  ///
  ///   expect(find.byType(NavigationBar), findsOneWidget);
  /// });
  /// ```
  ///
  /// The width is the smallest one of the breakpoint - 360 for mini - under
  /// [behaviour]. See `HydraVariant` to run a test at every breakpoint.
  void setBreakpoint(
    Breakpoint breakpoint, {
    HydraBehaviour behaviour = const HydraBehaviour(),
    double height = 800,
  }) {
    resizeToBreakpoint(view, breakpoint, behaviour: behaviour, height: height);
    addTearDown(() => resetView(view));
  }
}
