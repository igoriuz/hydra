# hydra_test

Test helpers for [hydra](https://pub.dev/packages/hydra): run a widget test once per breakpoint, or set the test screen to a breakpoint.

## Installation

```bash
flutter pub add dev:hydra_test
```

```dart
import 'package:hydra_test/hydra_test.dart';
```

## Every breakpoint

`HydraVariant` runs a `testWidgets` once per breakpoint, with the test screen resized to it:

```dart
final breakpoints = HydraVariant();

testWidgets('shows the navigation for the screen', variant: breakpoints,
    (tester) async {
  await tester.pumpWidget(const MyApp());

  final wide = breakpoints.currentValue! >= Breakpoint.medium;
  expect(find.byType(NavigationRail), wide ? findsOneWidget : findsNothing);
});
```

The test shows up once per breakpoint, as `shows the navigation for the screen (variant: mini)` and so on.

Pick breakpoints and pass the behaviour your app uses:

```dart
final breakpoints = HydraVariant(
  breakpoints: {Breakpoint.mini, Breakpoint.large},
  behaviour: const HydraBehaviour.material(),
);
```

## One breakpoint

`setBreakpoint` resizes the test screen for a single test and restores it afterwards:

```dart
testWidgets('shows a bottom bar on phones', (tester) async {
  tester.setBreakpoint(Breakpoint.mini);
  await tester.pumpWidget(const MyApp());

  expect(find.byType(NavigationBar), findsOneWidget);
});
```

## Screen sizes

Each breakpoint gets its smallest width, so tests also check the edge of every range: `small`, `medium` and `large` start exactly at their breakpoint, `mini` is 360 px wide. The height is 800 px unless you pass another one; without orientation awareness it is raised to at least the width, as Hydra then reads the shortest side.

## License

MIT
