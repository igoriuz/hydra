<img src="https://raw.githubusercontent.com/igoriuz/hydra/main/.github/logo.png" height="120" alt="Hydra Logo" />

# Hydra

[![pub package](https://img.shields.io/pub/v/hydra.svg)](https://pub.dev/packages/hydra)
[![CI](https://github.com/igoriuz/hydra/actions/workflows/ci.yml/badge.svg)](https://github.com/igoriuz/hydra/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/igoriuz/hydra/branch/main/graph/badge.svg)](https://codecov.io/gh/igoriuz/hydra)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

Responsive layouts are like the Hydra of Greek mythology - cut off one screen size and two more appear. Phone, tablet, foldable, desktop, ultrawide... every time you think you've handled them all, a new head grows.

Hydra tames the beast. Define up to four layout variants and let it pick the right one - with zero additional dependencies beyond Flutter itself.

## Highlights

- **Responsive widgets** - swap entire widgets based on screen size
- **Responsive values** - adapt padding, font sizes, colors or any type `T`
- **Smart fallbacks** - you don't need a variant for every breakpoint
- **Zero dependencies** - only Flutter SDK, nothing else
- **100% test coverage** - every line, every head

## Installation

```bash
flutter pub add hydra
```

## Responsive Widgets

Use `HydraWidget` to display different widgets based on the current breakpoint:

```dart
import 'package:hydra/hydra.dart';

HydraWidget(
  mini: const Text('Phone'),
  medium: const Text('Tablet'),
  large: const Text('Desktop'),
)
```

Hydra selects the best match for the current screen width. If no exact match exists, it falls back to the nearest available alternative.

## Responsive Values

Use `HydraValue<T>` when you need a responsive value instead of a whole widget:

```dart
final padding = HydraValue<double>(mini: 8, small: 16, large: 32);

@override
Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(padding.resolve(context)),
    child: content,
  );
}
```

Or use the `BuildContext` extension for inline usage:

```dart
@override
Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(context.hydra<double>(mini: 8, large: 32)),
    child: Text(
      'Hello',
      style: TextStyle(
        fontSize: context.hydra<double>(mini: 14, medium: 16, large: 20),
      ),
    ),
  );
}
```

Works with any type - `double`, `EdgeInsets`, `TextStyle`, `Color`, or your own types.

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

Both `HydraWidget` and `HydraValue<T>` accept a `behaviour` parameter with the same options.

## Behaviour Options

| Constructor | Description |
|---|---|
| `HydraBehaviour()` | Default: orientation-aware, prefers larger fallback |
| `HydraBehaviour.preferSmaller()` | Falls back to smaller alternative instead of larger |
| `HydraBehaviour.noOrientation()` | Uses shortest side regardless of orientation |
| `HydraBehaviour.material()` | Material Design breakpoints (600/840/1200) |

### Orientation Awareness

By default, Hydra uses `MediaQuery.sizeOf(context).width` which changes when the device rotates. Set `isOrientationAware: false` (or use `HydraBehaviour.noOrientation()`) to use the shortest side instead - the layout stays consistent regardless of rotation.

## How It Works

1. **Breakpoint detection** - determines the current breakpoint from screen width
2. **Exact match** - looks for a widget or value registered at that breakpoint
3. **Nearest fallback** - if no exact match, picks the closest available alternative (prefers larger by default, configurable via `isSmallerScreenPreferred`)

## License

MIT
