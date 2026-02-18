# Hydra Modernization Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Modernize the Hydra Flutter package from Dart 2.x to 3.5+, remove dead code, and set up CI/CD with automated pub.dev publishing.

**Architecture:** Two sequential PRs — first cleanup & modernization, then CI/CD. The default branch is renamed from `master` to `main` before any feature work. All code changes follow TDD: verify existing tests pass, then refactor while keeping them green.

**Tech Stack:** Dart 3.5+, Flutter 3.22+, flutter_lints ^6.0.0, GitHub Actions (subosito/flutter-action, dart-lang/setup-dart)

---

## PR 1: Cleanup, Modernization & Optimizations

### Task 1: Rename default branch master → main

**Step 1: Rename local branch**

```bash
git branch -m master main
```

**Step 2: Push new branch and update remote HEAD**

```bash
git push -u origin main
```

**Step 3: Update default branch on GitHub**

Go to GitHub repo Settings → Branches → change default branch to `main`. Or use:

```bash
gh api repos/igoriuz/hydra -X PATCH -f default_branch=main
```

**Step 4: Delete old remote branch**

```bash
git push origin --delete master
```

**Step 5: Commit** — no commit needed, branch operation only.

---

### Task 2: Create feature branch

**Step 1: Create and push feature branch**

```bash
git checkout -b chore/modernize
git push -u origin chore/modernize
```

---

### Task 3: Update SDK constraints and dependencies

**Files:**
- Modify: `pubspec.yaml`
- Modify: `analysis_options.yaml`

**Step 1: Update `pubspec.yaml`**

Replace the full contents with:

```yaml
name: hydra
description: Flutter widget which helps building responsive widgets.
version: 1.0.0
homepage: https://github.com/igoriuz/hydra
issue_tracker: https://github.com/igoriuz/hydra/issues
repository: https://github.com/igoriuz/hydra
topics:
  - responsive
  - widget
  - breakpoint
  - layout

environment:
  sdk: '>=3.5.0 <4.0.0'
  flutter: '>=3.24.0'

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

**Step 2: Update `analysis_options.yaml`**

Replace contents with:

```yaml
include: package:flutter_lints/flutter.yaml
```

**Step 3: Run `flutter pub get`**

```bash
cd /Users/igor/Private/hydra && flutter pub get
```

Expected: Dependencies resolve successfully.

**Step 4: Run existing tests to see current state**

```bash
cd /Users/igor/Private/hydra && flutter test
```

Expected: Tests will likely fail due to null-safety issues in the pre-null-safety code. Note the errors for the next tasks.

**Step 5: Commit**

```bash
git add pubspec.yaml analysis_options.yaml
git commit -m "chore: update SDK to >=3.5.0, replace pedantic with flutter_lints"
```

---

### Task 4: Delete dead code

**Files:**
- Delete: `lib/src/context_behavior_ext.dart`
- Delete: `lib/src/hydra_neck.dart`
- Modify: `lib/hydra.dart`

**Step 1: Delete dead files**

```bash
rm lib/src/context_behavior_ext.dart lib/src/hydra_neck.dart
```

**Step 2: Update `lib/hydra.dart` exports**

Replace full contents with:

```dart
/// Flutter widget which helps building responsive widgets.
library hydra;

export 'package:hydra/src/hydra_behaviour.dart';
export 'package:hydra/src/hydra_head.dart';
export 'package:hydra/src/hydra_widget.dart';
export 'package:hydra/src/hydra_no_widget_exception.dart';
```

**Step 3: Commit**

```bash
git add -A lib/
git commit -m "chore: remove unused HydraNeck and commented-out context_behavior_ext"
```

---

### Task 5: Modernize HydraBehaviour

**Files:**
- Modify: `lib/src/hydra_behaviour.dart`

**Step 1: Update `lib/src/hydra_behaviour.dart`**

Replace full contents with:

```dart
import 'package:hydra/src/breakpoint.dart';

/// Breakpoint to distinguish the width of the device.
const double kSmallBP = 90;

/// Breakpoint to distinguish the width of the device.
const double kMediumBP = 400;

/// Breakpoint to distinguish the width of the device.
const double kLargeBP = 800;

/// {@template hydra_behaviour}
/// [HydraBehaviour] defines behaviour for [HydraWidget].
///
/// In order to decide which device type is used, [HydraBehaviour] exposes
/// [breakpointSmall], [breakpointMedium] and [breakpointLarge].
///
/// [isOrientationAware] defines what should happen when the device is rotated.
/// If it's not aware, then the shortest side is used.
///
/// [isSmallerScreenPreferred] is set to `false` by default, assuming that
/// bigger screens are preferred if there is no screen at the current breakpoint.
///
/// ```dart
/// HydraBehaviour(
///   breakpointSmall: kSmallBP,
///   breakpointMedium: kMediumBP,
///   breakpointLarge: kLargeBP,
///   isOrientationAware: false,
///   isSmallerScreenPreferred: true,
/// )
/// ```
///
/// Default breakpoints are defined in [kSmallBP], [kMediumBP] and [kLargeBP].
/// {@endtemplate}
class HydraBehaviour {
  /// Breakpoint threshold between [Breakpoint.mini] and [Breakpoint.small].
  final double breakpointSmall;

  /// Breakpoint threshold between [Breakpoint.small] and [Breakpoint.medium].
  final double breakpointMedium;

  /// Breakpoint threshold between [Breakpoint.medium] and [Breakpoint.large].
  final double breakpointLarge;

  /// Whether the widget should re-evaluate when device orientation changes.
  final bool isOrientationAware;

  /// Whether to prefer smaller screen alternatives when no exact match exists.
  final bool isSmallerScreenPreferred;

  /// {@macro hydra_behaviour}
  const HydraBehaviour({
    this.breakpointSmall = kSmallBP,
    this.breakpointMedium = kMediumBP,
    this.breakpointLarge = kLargeBP,
    this.isOrientationAware = true,
    this.isSmallerScreenPreferred = false,
  })  : assert(breakpointSmall < breakpointMedium),
        assert(breakpointMedium < breakpointLarge);

  /// Default behaviour except that [isSmallerScreenPreferred] is set to `true`.
  const HydraBehaviour.preferSmaller({
    double breakpointSmall = kSmallBP,
    double breakpointMedium = kMediumBP,
    double breakpointLarge = kLargeBP,
    bool isOrientationAware = true,
  })  : breakpointSmall = breakpointSmall,
        breakpointMedium = breakpointMedium,
        breakpointLarge = breakpointLarge,
        isOrientationAware = isOrientationAware,
        isSmallerScreenPreferred = true,
        assert(breakpointSmall < breakpointMedium),
        assert(breakpointMedium < breakpointLarge);

  /// Default behaviour except that the shortest side will be used. This means
  /// that even when the device is rotated, [HydraWidget] won't choose a
  /// different screen alternative.
  const HydraBehaviour.noOrientation({
    double breakpointSmall = kSmallBP,
    double breakpointMedium = kMediumBP,
    double breakpointLarge = kLargeBP,
    bool isSmallerScreenPreferred = false,
  })  : breakpointSmall = breakpointSmall,
        breakpointMedium = breakpointMedium,
        breakpointLarge = breakpointLarge,
        isOrientationAware = false,
        isSmallerScreenPreferred = isSmallerScreenPreferred,
        assert(breakpointSmall < breakpointMedium),
        assert(breakpointMedium < breakpointLarge);
}
```

Key changes:
- Removed `import 'package:hydra/hydra.dart'` (was a circular-ish import, only needed for the `HydraWidget` reference in docs)
- Removed `assert(isOrientationAware != null)` and `assert(isSmallerScreenPreferred != null)` — not needed with null safety
- Changed factory constructors to `const` named constructors (allows const usage)
- Improved dartdoc comments on fields

**Step 2: Verify it compiles**

```bash
cd /Users/igor/Private/hydra && flutter analyze lib/src/hydra_behaviour.dart
```

Expected: No issues.

**Step 3: Commit**

```bash
git add lib/src/hydra_behaviour.dart
git commit -m "refactor: modernize HydraBehaviour for null safety and const support"
```

---

### Task 6: Modernize HydraHead

**Files:**
- Modify: `lib/src/hydra_head.dart`

**Step 1: Update `lib/src/hydra_head.dart`**

Replace full contents with:

```dart
import 'package:flutter/material.dart';

import 'breakpoint.dart';

/// {@template hydra_head}
/// [HydraHead] pairs a [widget] with a [breakpoint] to define which device
/// type the widget is intended for.
/// {@endtemplate}
class HydraHead {
  /// The widget to display for this breakpoint.
  final Widget widget;

  /// The device type breakpoint this head targets.
  final Breakpoint breakpoint;

  const HydraHead._(this.widget, this.breakpoint);

  /// Creates a [HydraHead] targeting [Breakpoint.mini].
  const factory HydraHead.mini(Widget widget) = _MiniHead;

  /// Creates a [HydraHead] targeting [Breakpoint.small].
  const factory HydraHead.small(Widget widget) = _SmallHead;

  /// Creates a [HydraHead] targeting [Breakpoint.medium].
  const factory HydraHead.medium(Widget widget) = _MediumHead;

  /// Creates a [HydraHead] targeting [Breakpoint.large].
  const factory HydraHead.large(Widget widget) = _LargeHead;
}

class _MiniHead extends HydraHead {
  const _MiniHead(Widget widget) : super._(widget, Breakpoint.mini);
}

class _SmallHead extends HydraHead {
  const _SmallHead(Widget widget) : super._(widget, Breakpoint.small);
}

class _MediumHead extends HydraHead {
  const _MediumHead(Widget widget) : super._(widget, Breakpoint.medium);
}

class _LargeHead extends HydraHead {
  const _LargeHead(Widget widget) : super._(widget, Breakpoint.large);
}
```

Key changes:
- Made constructor `const`
- Used `const factory` redirecting constructors (allows const HydraHead creation)
- Improved dartdoc

**Step 2: Verify it compiles**

```bash
cd /Users/igor/Private/hydra && flutter analyze lib/src/hydra_head.dart
```

**Step 3: Commit**

```bash
git add lib/src/hydra_head.dart
git commit -m "refactor: modernize HydraHead with const constructors"
```

---

### Task 7: Modernize HydraWidget

**Files:**
- Modify: `lib/src/hydra_widget.dart`

**Step 1: Update `lib/src/hydra_widget.dart`**

Replace full contents with:

```dart
import 'package:flutter/material.dart';

import 'breakpoint.dart';
import 'hydra_behaviour.dart';
import 'hydra_head.dart';
import 'hydra_no_widget_exception.dart';

/// [HydraWidget] is a [StatelessWidget] that selects which widget to display
/// based on the current screen size and [behaviour] configuration.
///
/// Up to four screen alternatives are supported: [mini], [small], [medium],
/// and [large]. At least one must be provided.
class HydraWidget extends StatelessWidget {
  /// {@macro hydra_behaviour}
  final HydraBehaviour behaviour;

  /// The resolved list of widget alternatives, ordered by preference.
  final List<HydraHead> widgets;

  HydraWidget({
    super.key,
    this.behaviour = const HydraBehaviour(),
    Widget? mini,
    Widget? small,
    Widget? medium,
    Widget? large,
  }) : widgets = _buildWidgetList(
         mini: mini,
         small: small,
         medium: medium,
         large: large,
         preferSmaller: behaviour.isSmallerScreenPreferred,
       );

  static List<HydraHead> _buildWidgetList({
    required Widget? mini,
    required Widget? small,
    required Widget? medium,
    required Widget? large,
    required bool preferSmaller,
  }) {
    final heads = <HydraHead>[
      if (large != null) HydraHead.large(large),
      if (medium != null) HydraHead.medium(medium),
      if (small != null) HydraHead.small(small),
      if (mini != null) HydraHead.mini(mini),
    ];

    if (heads.isEmpty) {
      throw HydraNoWidgetException('At least one widget is needed');
    }

    return preferSmaller ? heads.reversed.toList() : heads;
  }

  @override
  Widget build(BuildContext context) {
    final width = comparableWidth(MediaQuery.of(context).size);
    return nearestWidget(width).widget;
  }

  /// Returns the comparable width based on orientation awareness.
  double comparableWidth(Size size) {
    return behaviour.isOrientationAware ? size.width : size.shortestSide;
  }

  /// Finds the best matching [HydraHead] for the given [comparable] width.
  HydraHead nearestWidget(double comparable) {
    final nearestBreakpoint = switch (comparable) {
      < kSmallBP => Breakpoint.mini,
      < kMediumBP => Breakpoint.small,
      < kLargeBP => Breakpoint.medium,
      _ => Breakpoint.large,
    };

    // Use custom breakpoints from behaviour (not just defaults)
    final effectiveBreakpoint = _breakpointForWidth(comparable);

    return widgets.firstWhere(
      (element) => element.breakpoint == effectiveBreakpoint,
      orElse: () => _closestAlternative(effectiveBreakpoint),
    );
  }

  Breakpoint _breakpointForWidth(double width) {
    if (width < behaviour.breakpointSmall) return Breakpoint.mini;
    if (width < behaviour.breakpointMedium) return Breakpoint.small;
    if (width < behaviour.breakpointLarge) return Breakpoint.medium;
    return Breakpoint.large;
  }

  /// Finds the widget with the shortest distance to [target] breakpoint.
  HydraHead _closestAlternative(Breakpoint target) {
    return widgets.reduce((a, b) {
      final distA = (target.index - a.breakpoint.index).abs();
      final distB = (target.index - b.breakpoint.index).abs();
      return distA <= distB ? a : b;
    });
  }
}
```

Key changes:
- `super.key` instead of `Key key` + `super(key: key)`
- `Widget?` nullable parameters (null safety)
- Initializer list with static helper `_buildWidgetList` instead of constructor body mutation
- Collection-if instead of imperative null checks
- `_breakpointForWidth` extracted from `nearestWidget` (uses behaviour's custom breakpoints)
- Removed dead code in `nearestWidget`: the old switch-expression approach used hardcoded `kSmallBP`/`kMediumBP`/`kLargeBP` — replaced with `_breakpointForWidth` that respects custom `behaviour` breakpoints
- `_closestAlternative` replaces `chooseAvailableWidget` — fixed bug where the filter `(index <= x) || (index >= x)` was always true
- `reduce` instead of manual loop with nullable accumulator

**Step 2: Verify it compiles**

```bash
cd /Users/igor/Private/hydra && flutter analyze lib/src/hydra_widget.dart
```

**Step 3: Commit**

```bash
git add lib/src/hydra_widget.dart
git commit -m "refactor: modernize HydraWidget with null safety, switch expressions, bug fix"
```

---

### Task 8: Modernize HydraNoWidgetException

**Files:**
- Modify: `lib/src/hydra_no_widget_exception.dart`

**Step 1: Update `lib/src/hydra_no_widget_exception.dart`**

Replace full contents with:

```dart
/// Exception thrown when no widget was provided to [HydraWidget].
class HydraNoWidgetException implements Exception {
  /// The error message.
  final String message;

  /// Creates a [HydraNoWidgetException] with the given [message].
  const HydraNoWidgetException(this.message);

  @override
  String toString() => 'HydraNoWidgetException: $message';
}
```

Key changes:
- `message` is now `final`
- Added `const` constructor
- Added `toString` override
- Removed import of `hydra.dart` (not needed)

**Step 2: Commit**

```bash
git add lib/src/hydra_no_widget_exception.dart
git commit -m "refactor: make HydraNoWidgetException const with final message"
```

---

### Task 9: Update tests

**Files:**
- Modify: `test/hydra_test.dart`
- Modify: `test/hydra_head_test.dart`
- Modify: `test/hydra_no_widget_exception_test.dart`

**Step 1: Update `test/hydra_test.dart`**

Replace full contents with:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';
import 'package:hydra/src/breakpoint.dart';

void main() {
  group('HydraWidget', () {
    final mini = Container();
    final small = Container();
    final medium = Container();
    final large = Container();

    group('with only one element in list', () {
      test('returns mini when only mini is available at mini breakpoint', () {
        const screenBP = 15.0;
        final hydra = HydraWidget(mini: mini);

        expect(hydra.widgets.length, 1);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.mini);
      });

      test('returns small when only small is available at large breakpoint', () {
        const screenBP = kLargeBP;
        final hydra = HydraWidget(small: small);

        expect(hydra.widgets.length, 1);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.small);
      });

      test('returns medium when only medium is available at small breakpoint', () {
        const screenBP = kSmallBP;
        final hydra = HydraWidget(medium: medium);

        expect(hydra.widgets.length, 1);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.medium);
      });

      test('returns large when only large is available at large breakpoint', () {
        const screenBP = kLargeBP;
        final hydra = HydraWidget(large: large);

        expect(hydra.widgets.length, 1);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.large);
      });
    });

    group('next bigger screen', () {
      test('small if only [mini, small] at large breakpoint', () {
        const screenBP = kLargeBP;
        final hydra = HydraWidget(mini: mini, small: small);

        expect(hydra.widgets.length, 2);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.small);
      });

      test('large if only [mini, large] at medium breakpoint', () {
        const screenBP = kMediumBP;
        final hydra = HydraWidget(mini: mini, large: large);

        expect(hydra.widgets.length, 2);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.large);
      });

      test('large if only [mini, small, large] at medium breakpoint', () {
        const screenBP = kMediumBP;
        final hydra = HydraWidget(mini: mini, small: small, large: large);

        expect(hydra.widgets.length, 3);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.large);
      });

      test('small if only [mini, small, large] at width between small and medium', () {
        const screenBP = kSmallBP + 5;
        final hydra = HydraWidget(mini: mini, small: small, large: large);

        expect(hydra.widgets.length, 3);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.small);
      });
    });

    group('orientation awareness', () {
      test('uses shortestSide when orientation awareness is off (vertical)', () {
        const verticalSize = Size(300, 700);
        final hydra = HydraWidget(
          mini: mini,
          behaviour: const HydraBehaviour.noOrientation(),
        );
        expect(hydra.comparableWidth(verticalSize), verticalSize.shortestSide);
      });

      test('uses shortestSide when orientation awareness is off (horizontal)', () {
        const horizontalSize = Size(700, 300);
        final hydra = HydraWidget(
          mini: mini,
          behaviour: const HydraBehaviour.noOrientation(),
        );
        expect(hydra.comparableWidth(horizontalSize), horizontalSize.shortestSide);
      });

      test('uses shortestSide for vertical device when orientation aware', () {
        const verticalSize = Size(300, 700);
        final hydra = HydraWidget(
          mini: mini,
          behaviour: const HydraBehaviour(isOrientationAware: true),
        );
        expect(hydra.comparableWidth(verticalSize), verticalSize.shortestSide);
      });

      test('uses width (longestSide) for horizontal device when orientation aware', () {
        const horizontalSize = Size(700, 300);
        final hydra = HydraWidget(
          mini: mini,
          behaviour: const HydraBehaviour(isOrientationAware: true),
        );
        expect(hydra.comparableWidth(horizontalSize), horizontalSize.longestSide);
      });
    });

    group('prefer smaller screen', () {
      test('small if only [mini, small] at large breakpoint', () {
        const screenBP = kLargeBP;
        final hydra = HydraWidget(
          mini: mini,
          small: small,
          behaviour: const HydraBehaviour.preferSmaller(),
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.small);
      });

      test('large if only [mini, large] at medium breakpoint (bigger preferred)', () {
        const screenBP = kMediumBP;
        final hydra = HydraWidget(
          mini: mini,
          large: large,
          behaviour: const HydraBehaviour(isSmallerScreenPreferred: false),
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.large);
      });
    });

    group('exact breakpoint match', () {
      test('mini at width 0', () {
        const screenBP = 0.0;
        final hydra = HydraWidget(
          mini: mini,
          small: small,
          behaviour: const HydraBehaviour.preferSmaller(),
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.mini);
      });

      test('medium at medium breakpoint', () {
        const screenBP = kMediumBP;
        final hydra = HydraWidget(
          mini: mini,
          medium: medium,
          large: large,
          behaviour: const HydraBehaviour.preferSmaller(),
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.medium);
      });

      test('small at medium width with smaller preferred', () {
        const screenBP = kMediumBP;
        final hydra = HydraWidget(
          small: small,
          mini: mini,
          large: large,
          behaviour: const HydraBehaviour.preferSmaller(),
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.small);
      });

      test('large at medium width with bigger preferred', () {
        const screenBP = kMediumBP;
        final hydra = HydraWidget(
          small: small,
          mini: mini,
          large: large,
          behaviour: const HydraBehaviour(isSmallerScreenPreferred: false),
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.large);
      });

      test('mini at width 0 with bigger preferred', () {
        const screenBP = 0.0;
        final hydra = HydraWidget(
          small: small,
          mini: mini,
          large: large,
          behaviour: const HydraBehaviour(isSmallerScreenPreferred: false),
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.mini);
      });

      test('medium at large width with smaller preferred', () {
        const screenBP = kLargeBP;
        final hydra = HydraWidget(
          small: small,
          mini: mini,
          medium: medium,
          behaviour: const HydraBehaviour(isSmallerScreenPreferred: true),
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.medium);
      });
    });
  });
}
```

**Step 2: Update `test/hydra_head_test.dart`**

Replace full contents with:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';
import 'package:hydra/src/breakpoint.dart';

void main() {
  group('HydraHead factories', () {
    final mini = HydraHead.mini(Container());
    final small = HydraHead.small(Container());
    final medium = HydraHead.medium(Container());
    final large = HydraHead.large(Container());

    group('breakpoint assignment', () {
      test('mini has Breakpoint.mini', () {
        expect(mini.breakpoint, Breakpoint.mini);
        expect(mini.breakpoint.index, 0);
      });

      test('small has Breakpoint.small', () {
        expect(small.breakpoint, Breakpoint.small);
        expect(small.breakpoint.index, 1);
      });

      test('medium has Breakpoint.medium', () {
        expect(medium.breakpoint, Breakpoint.medium);
        expect(medium.breakpoint.index, 2);
      });

      test('large has Breakpoint.large', () {
        expect(large.breakpoint, Breakpoint.large);
        expect(large.breakpoint.index, 3);
      });
    });

    group('ordinal comparison', () {
      test('mini < small < medium < large', () {
        expect(mini.breakpoint.index, lessThan(small.breakpoint.index));
        expect(small.breakpoint.index, lessThan(medium.breakpoint.index));
        expect(medium.breakpoint.index, lessThan(large.breakpoint.index));
      });
    });
  });
}
```

**Step 3: Update `test/hydra_no_widget_exception_test.dart`**

Replace full contents with:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';

void main() {
  group('HydraNoWidgetException', () {
    test('throws when no widgets are given', () {
      expect(
        () => HydraWidget(),
        throwsA(isA<HydraNoWidgetException>()),
      );
    });

    test('has a descriptive toString', () {
      const exception = HydraNoWidgetException('test message');
      expect(exception.toString(), 'HydraNoWidgetException: test message');
    });
  });
}
```

**Step 4: Run all tests**

```bash
cd /Users/igor/Private/hydra && flutter test
```

Expected: All tests pass.

**Step 5: Run analysis**

```bash
cd /Users/igor/Private/hydra && flutter analyze
```

Expected: No issues found.

**Step 6: Run formatter**

```bash
cd /Users/igor/Private/hydra && dart format .
```

**Step 7: Commit**

```bash
git add test/
git commit -m "test: update tests for null safety and modern assertions"
```

---

### Task 10: Update example app

**Files:**
- Modify: `example/pubspec.yaml`
- Modify: `example/lib/main.dart`

**Step 1: Update `example/pubspec.yaml`**

Replace full contents with:

```yaml
name: example
description: Example app demonstrating the Hydra package.

version: 1.0.0+1

environment:
  sdk: '>=3.5.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  hydra:
    path: ../

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
```

**Step 2: Update `example/lib/main.dart`**

Replace full contents with:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydra/hydra.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hydra Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HydraWidget(
      behaviour: const HydraBehaviour(
        breakpointSmall: kSmallBP,
        breakpointMedium: kMediumBP,
        breakpointLarge: kLargeBP,
        isOrientationAware: false,
        isSmallerScreenPreferred: true,
      ),
      small: _buildForMobile(),
      medium: _buildForTablet(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: _counter + 1,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => Card(
        color: index % 2 == 0 ? Colors.green : Colors.greenAccent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Item $index'),
        ),
      ),
    );
  }

  Widget _buildScaffold(String title, Widget content) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: content,
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildForTablet() {
    return _buildScaffold(
      'Rotated Mobile / Tablet Demo',
      Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(42.0),
          child: Stack(
            children: [
              Positioned(
                left: MediaQuery.of(context).size.width * .45,
                top: 0,
                bottom: 0,
                right: 64,
                child: SingleChildScrollView(child: _buildList()),
              ),
              Positioned.fill(
                right: MediaQuery.of(context).size.width * .55,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildChildren(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForMobile() {
    return _buildScaffold(
      'Mobile Demo',
      Padding(
        padding: const EdgeInsets.all(28.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ..._buildChildren(),
              _buildList(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    return [
      Container(
        color: Colors.orange,
        child: const Text('You have pushed the button this many times:'),
      ),
      Builder(
        builder: (context) => Text(
          '$_counter',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    ];
  }
}
```

Key changes:
- `const` constructors everywhere
- `super.key` instead of `Key? key`
- `State<MyHomePage>` instead of `_MyHomePageState`
- `headlineMedium` instead of deprecated `headline4`
- Spread operator instead of cascade `..add()`
- Trailing commas, formatting

**Step 3: Run flutter pub get in example**

```bash
cd /Users/igor/Private/hydra/example && flutter pub get
```

**Step 4: Commit**

```bash
cd /Users/igor/Private/hydra
git add example/
git commit -m "chore: update example app for Dart 3.5+ and modern Flutter"
```

---

### Task 11: Update metadata and version

**Files:**
- Modify: `LICENSE`
- Modify: `CHANGELOG.md`
- Modify: `README.md`
- Delete: `.metadata`

**Step 1: Update LICENSE copyright year**

Change `Copyright (c) 2020 Igor Kazhdan` to `Copyright (c) 2020-2026 Igor Kazhdan`.

**Step 2: Update README logo URL**

The logo URL references `master` branch. Update to `main`:

```markdown
<img src="https://raw.githubusercontent.com/igoriuz/hydra/main/.github/logo.png" height="120" alt="Hydra Logo" />
```

**Step 3: Update CHANGELOG.md**

Replace full contents with:

```markdown
# 1.0.0

* **Breaking:** Removed unused `HydraNeck` class
* **Breaking:** Removed commented-out `BreakpointExtension`
* **Breaking:** Minimum SDK constraint is now `>=3.5.0`
* Migrated to null safety
* Replaced deprecated `pedantic` with `flutter_lints`
* Made `HydraBehaviour` named constructors `const`
* Made `HydraHead` constructors `const`
* Made `HydraNoWidgetException` `const` with `final` message
* Used switch expressions and collection-if in `HydraWidget`
* Fixed bug in `chooseAvailableWidget` where filter was always true
* Updated example app to modern Flutter conventions
* Added `topics` to `pubspec.yaml` for pub.dev discoverability

# 0.1.0

* Initial version of this package
```

**Step 4: Delete `.metadata` (Flutter auto-generated, not needed for packages)**

```bash
rm /Users/igor/Private/hydra/.metadata
```

**Step 5: Commit**

```bash
cd /Users/igor/Private/hydra
git add LICENSE CHANGELOG.md README.md
git rm .metadata 2>/dev/null; true
git commit -m "chore: update metadata, changelog, and version to 1.0.0"
```

---

### Task 12: Final verification for PR 1

**Step 1: Run full test suite**

```bash
cd /Users/igor/Private/hydra && flutter test
```

Expected: All tests pass.

**Step 2: Run analysis**

```bash
cd /Users/igor/Private/hydra && flutter analyze
```

Expected: No issues found.

**Step 3: Check formatting**

```bash
cd /Users/igor/Private/hydra && dart format --set-exit-if-changed .
```

Expected: No changes needed.

**Step 4: Dry-run publish**

```bash
cd /Users/igor/Private/hydra && dart pub publish --dry-run
```

Expected: Package is ready to publish (possibly with hints about missing screenshots etc., which is fine).

**Step 5: Create PR**

```bash
gh pr create --base main --title "chore: modernize package for Dart 3.5+" --body "$(cat <<'EOF'
## Summary
- Updated SDK constraint to `>=3.5.0 <4.0.0`
- Replaced deprecated `pedantic` with `flutter_lints` ^6.0.0
- Removed dead code (`HydraNeck`, commented-out `BreakpointExtension`)
- Modernized all source files for null safety, const constructors, switch expressions
- Fixed bug in `chooseAvailableWidget` where filter condition was always true
- Updated tests, example app, and metadata
- Bumped version to 1.0.0

## Test plan
- [ ] `flutter test` passes
- [ ] `flutter analyze` has no issues
- [ ] `dart format --set-exit-if-changed .` passes
- [ ] `dart pub publish --dry-run` succeeds
- [ ] Example app builds and runs
EOF
)"
```

---

## PR 2: CI/CD Pipeline

### Task 13: Create feature branch for CI/CD

**Step 1: Switch to main and create new branch**

```bash
git checkout main
git pull origin main
git checkout -b chore/ci-cd
```

---

### Task 14: Create CI workflow

**Files:**
- Create: `.github/workflows/ci.yml`

**Step 1: Create `.github/workflows/ci.yml`**

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  analyze-and-test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          channel: stable

      - name: Install dependencies
        run: flutter pub get

      - name: Check formatting
        run: dart format --set-exit-if-changed .

      - name: Analyze
        run: flutter analyze

      - name: Run tests with coverage
        run: flutter test --coverage

      - name: Verify publishable
        run: dart pub publish --dry-run
```

**Step 2: Commit**

```bash
cd /Users/igor/Private/hydra
git add .github/workflows/ci.yml
git commit -m "ci: add CI workflow with analyze, test, format, and publish dry-run"
```

---

### Task 15: Create publish workflow

**Files:**
- Create: `.github/workflows/publish.yml`

**Step 1: Create `.github/workflows/publish.yml`**

```yaml
name: Publish to pub.dev

on:
  push:
    tags:
      - 'v[0-9]+.[0-9]+.[0-9]+'

jobs:
  publish:
    permissions:
      id-token: write
    uses: dart-lang/setup-dart/.github/workflows/publish.yml@v1
```

**Step 2: Commit**

```bash
cd /Users/igor/Private/hydra
git add .github/workflows/publish.yml
git commit -m "ci: add automated pub.dev publishing on tag push"
```

---

### Task 16: Create dependabot config

**Files:**
- Create: `.github/dependabot.yml`

**Step 1: Create `.github/dependabot.yml`**

```yaml
version: 2

updates:
  - package-ecosystem: github-actions
    directory: /
    schedule:
      interval: monthly
```

**Step 2: Commit**

```bash
cd /Users/igor/Private/hydra
git add .github/dependabot.yml
git commit -m "ci: add dependabot for GitHub Actions updates"
```

---

### Task 17: Create PR for CI/CD

**Step 1: Push and create PR**

```bash
git push -u origin chore/ci-cd

gh pr create --base main --title "ci: add CI/CD pipeline with automated pub.dev publishing" --body "$(cat <<'EOF'
## Summary
- Added CI workflow: format check, analyze, test with coverage, publish dry-run
- Added publish workflow: tag-based (`v*`) automated publishing to pub.dev via OIDC
- Added dependabot config for monthly GitHub Actions updates

## Setup required after merge
- [ ] Go to pub.dev → hydra → Admin → Automated publishing
- [ ] Enable "Publishing from GitHub Actions"
- [ ] Set repository to `igoriuz/hydra`
- [ ] Set tag pattern to `v{{version}}`

## Test plan
- [ ] CI workflow runs on this PR
- [ ] After merge + pub.dev setup, test with `git tag v1.0.0 && git push origin v1.0.0`
EOF
)"
```

---

## Post-merge checklist

After both PRs are merged:

1. Configure pub.dev automated publishing (Admin → Automated publishing → GitHub Actions → `igoriuz/hydra` → `v{{version}}`)
2. Tag and push: `git tag v1.0.0 && git push origin v1.0.0`
3. Verify the publish workflow runs and the package appears on pub.dev
