# README Redesign & Breakpoint Presets Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Redesign the README for pub.dev standards, export the Breakpoint enum, update default breakpoints to sensible values, and add a Material Design preset.

**Architecture:** Single PR with code changes first (export, defaults, preset), then tests, then README. All tests use the `kSmallBP`/`kMediumBP`/`kLargeBP` constants so changing defaults won't break them.

**Tech Stack:** Dart 3.5+, Flutter, flutter_test

---

### Task 1: Create feature branch

**Step 1: Create branch**

```bash
git checkout main && git pull origin main
git checkout -b feat/readme-and-presets
```

---

### Task 2: Export Breakpoint enum

**Files:**
- Modify: `lib/hydra.dart`

**Step 1: Add export**

Add this line to `lib/hydra.dart` after the existing exports:

```dart
export 'package:hydra/src/breakpoint.dart';
```

**Step 2: Verify tests still import correctly**

The tests already import `package:hydra/src/breakpoint.dart` directly. With the public export, they can now also use `package:hydra/hydra.dart`. No test changes needed — both import paths work.

```bash
flutter test
```

Expected: All 27 tests pass.

**Step 3: Commit**

```bash
git add lib/hydra.dart
git commit -m "feat: export Breakpoint enum as public API"
```

---

### Task 3: Update default breakpoints and add Material preset

**Files:**
- Modify: `lib/src/hydra_behaviour.dart`

**Step 1: Update default breakpoint constants**

In `lib/src/hydra_behaviour.dart`, change lines 4-10:

Old:
```dart
const double kSmallBP = 90;
const double kMediumBP = 400;
const double kLargeBP = 800;
```

New:
```dart
const double kSmallBP = 600;
const double kMediumBP = 900;
const double kLargeBP = 1200;
```

**Step 2: Add Material Design preset constructor**

Add after the existing `HydraBehaviour.noOrientation` constructor (before the closing `}`):

```dart
  /// Breakpoints based on Material Design layout guidelines.
  ///
  /// - mini: < 600
  /// - small: 600–839
  /// - medium: 840–1199
  /// - large: >= 1200
  ///
  /// See: https://m3.material.io/foundations/layout/applying-layout
  const HydraBehaviour.material({
    this.isOrientationAware = true,
    this.isSmallerScreenPreferred = false,
  })  : breakpointSmall = 600,
        breakpointMedium = 840,
        breakpointLarge = 1200,
        assert(600 < 840),
        assert(840 < 1200);
```

**Step 3: Run tests**

```bash
flutter test
```

Expected: All 27 tests pass (tests use `kSmallBP`/`kMediumBP`/`kLargeBP` constants, not hardcoded values).

**Step 4: Commit**

```bash
git add lib/src/hydra_behaviour.dart
git commit -m "feat: update default breakpoints to 600/900/1200 and add material preset"
```

---

### Task 4: Add tests for Material preset

**Files:**
- Modify: `test/hydra_test.dart`

**Step 1: Add test group**

Add a new group inside the `'HydraWidget'` group, after the `'exact breakpoint match'` group:

```dart
    group('material preset', () {
      test('uses Material Design breakpoints', () {
        final hydra = HydraWidget(
          mini: mini,
          small: small,
          medium: medium,
          large: large,
          behaviour: const HydraBehaviour.material(),
        );

        expect(hydra.nearestWidget(0).breakpoint, Breakpoint.mini);
        expect(hydra.nearestWidget(599).breakpoint, Breakpoint.mini);
        expect(hydra.nearestWidget(600).breakpoint, Breakpoint.small);
        expect(hydra.nearestWidget(839).breakpoint, Breakpoint.small);
        expect(hydra.nearestWidget(840).breakpoint, Breakpoint.medium);
        expect(hydra.nearestWidget(1199).breakpoint, Breakpoint.medium);
        expect(hydra.nearestWidget(1200).breakpoint, Breakpoint.large);
      });
    });
```

**Step 2: Run tests**

```bash
flutter test
```

Expected: All 28 tests pass.

**Step 3: Commit**

```bash
git add test/hydra_test.dart
git commit -m "test: add tests for Material Design preset"
```

---

### Task 5: Rewrite README

**Files:**
- Modify: `README.md`

**Step 1: Replace README.md with:**

```markdown
<img src="https://raw.githubusercontent.com/igoriuz/hydra/main/.github/logo.png" height="120" alt="Hydra Logo" />

# Hydra

[![pub package](https://img.shields.io/pub/v/hydra.svg)](https://pub.dev/packages/hydra)
[![CI](https://github.com/igoriuz/hydra/actions/workflows/ci.yml/badge.svg)](https://github.com/igoriuz/hydra/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Build responsive Flutter widgets with ease. Define up to four layout variants and let Hydra pick the right one based on screen size.

## Installation

```bash
flutter pub add hydra
```

## Quick Start

```dart
import 'package:hydra/hydra.dart';

HydraWidget(
  mini: const Text('Phone'),
  medium: const Text('Tablet'),
  large: const Text('Desktop'),
)
```

Hydra selects the best match for the current screen width. If no exact match exists, it falls back to the nearest available alternative.

## Breakpoints

Default breakpoints: **600** (small), **900** (medium), **1200** (large). Everything below 600 is considered `mini`.

```dart
// Use defaults
HydraWidget(
  behaviour: const HydraBehaviour(),
  mini: mobileLayout(),
  large: desktopLayout(),
)

// Custom breakpoints
HydraWidget(
  behaviour: const HydraBehaviour(
    breakpointSmall: 480,
    breakpointMedium: 768,
    breakpointLarge: 1024,
  ),
  small: mobileLayout(),
  medium: tabletLayout(),
  large: desktopLayout(),
)

// Material Design breakpoints (600 / 840 / 1200)
HydraWidget(
  behaviour: const HydraBehaviour.material(),
  mini: compactLayout(),
  small: mediumLayout(),
  large: expandedLayout(),
)
```

## Behaviour Options

| Constructor | Description |
|---|---|
| `HydraBehaviour()` | Default: orientation-aware, prefers larger fallback |
| `HydraBehaviour.preferSmaller()` | Falls back to smaller alternative instead of larger |
| `HydraBehaviour.noOrientation()` | Uses shortest side regardless of orientation |
| `HydraBehaviour.material()` | Material Design breakpoints (600/840/1200) |

### Orientation Awareness

By default, Hydra uses `MediaQuery.of(context).size.width` which changes when the device rotates. Set `isOrientationAware: false` (or use `HydraBehaviour.noOrientation()`) to use the shortest side instead — the layout stays consistent regardless of rotation.

## How It Works

1. **Breakpoint detection** — determines the current breakpoint from screen width
2. **Exact match** — looks for a widget registered at that breakpoint
3. **Nearest fallback** — if no exact match, picks the closest available alternative (prefers larger by default, configurable via `isSmallerScreenPreferred`)

## License

MIT
```

**Step 2: Format check**

```bash
dart format --set-exit-if-changed .
```

**Step 3: Commit**

```bash
git add README.md
git commit -m "docs: rewrite README with pub.dev conventions and code examples"
```

---

### Task 6: Update version and changelog

**Files:**
- Modify: `pubspec.yaml`
- Modify: `CHANGELOG.md`

**Step 1: Bump version in `pubspec.yaml`**

Change `version: 1.0.0` to `version: 1.1.0`.

**Step 2: Update CHANGELOG.md**

Prepend above the `# 1.0.0` section:

```markdown
# 1.1.0

* **Breaking:** Default breakpoints changed from 90/400/800 to 600/900/1200
* Added `HydraBehaviour.material()` preset with Material Design breakpoints (600/840/1200)
* Exported `Breakpoint` enum as public API
* Rewrote README with installation guide, code examples, and badges

```

**Step 3: Commit**

```bash
git add pubspec.yaml CHANGELOG.md
git commit -m "chore: bump version to 1.1.0 and update changelog"
```

---

### Task 7: Final verification and PR

**Step 1: Run all checks**

```bash
flutter test
flutter analyze
dart format --set-exit-if-changed .
flutter pub publish --dry-run
```

Expected: All pass.

**Step 2: Push and create PR**

```bash
git push -u origin feat/readme-and-presets

gh pr create --base main --title "feat: redesign README, update breakpoints, add material preset" --body "$(cat <<'EOF'
## Summary
- Exported `Breakpoint` enum as public API
- Updated default breakpoints from 90/400/800 to 600/900/1200
- Added `HydraBehaviour.material()` preset (600/840/1200)
- Rewrote README with pub.dev conventions (badges, installation, code examples)
- Bumped version to 1.1.0

## Breaking Changes
- Default breakpoints changed: `kSmallBP` 90→600, `kMediumBP` 400→900, `kLargeBP` 800→1200

## Test plan
- [ ] `flutter test` passes (28 tests)
- [ ] `flutter analyze` clean
- [ ] `dart format --set-exit-if-changed .` passes
- [ ] `flutter pub publish --dry-run` passes
EOF
)"
```
