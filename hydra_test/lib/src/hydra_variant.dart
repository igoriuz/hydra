import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';
import 'package:hydra_test/src/test_view.dart';

/// [HydraVariant] runs a widget test once per breakpoint, with the test
/// screen resized to that breakpoint.
///
/// ```dart
/// final breakpoints = HydraVariant();
///
/// testWidgets('shows the navigation for the screen', (tester) async {
///   await tester.pumpWidget(const MyApp());
///
///   final wide = breakpoints.currentValue! >= Breakpoint.medium;
///   expect(find.byType(NavigationRail), wide ? findsOneWidget : findsNothing);
/// }, variant: breakpoints);
/// ```
///
/// Each breakpoint gets its smallest width - 360 for mini - so the test
/// also checks the edge of every range. Pass the [behaviour] your app uses,
/// for example the one of its `HydraScope`.
class HydraVariant extends TestVariant<Breakpoint> {
  /// Creates a [HydraVariant] for [breakpoints], all of them by default.
  HydraVariant({
    Set<Breakpoint>? breakpoints,
    this.behaviour = const HydraBehaviour(),
    this.height = 800,
  }) : values = breakpoints ?? Breakpoint.values.toSet();

  @override
  final Set<Breakpoint> values;

  /// The behaviour whose breakpoints decide the screen widths.
  final HydraBehaviour behaviour;

  /// The height of the test screen in logical pixels.
  final double height;

  /// The breakpoint of the test that is running, `null` outside a test.
  Breakpoint? currentValue;

  @override
  String describeValue(Breakpoint value) => value.name;

  @override
  Future<Object?> setUp(Breakpoint value) async {
    currentValue = value;
    resizeToBreakpoint(
      _view,
      value,
      behaviour: behaviour,
      height: height,
    );
    return null;
  }

  @override
  Future<void> tearDown(Breakpoint value, Object? memento) async {
    currentValue = null;
    resetView(_view);
  }

  TestFlutterView get _view {
    return TestWidgetsFlutterBinding.instance.platformDispatcher.implicitView!;
  }
}
