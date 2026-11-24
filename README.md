<img src="https://raw.githubusercontent.com/igoriuz/hydra/main/.github/logo.png" height="120" alt="Hydra Logo" />

# Hydra

[![pub package](https://img.shields.io/pub/v/hydra.svg)](https://pub.dev/packages/hydra)
[![CI](https://github.com/igoriuz/hydra/actions/workflows/ci.yml/badge.svg)](https://github.com/igoriuz/hydra/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/igoriuz/hydra/branch/main/graph/badge.svg)](https://codecov.io/gh/igoriuz/hydra)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

Responsive layouts are like the Hydra of Greek mythology - cut off one screen size and two more appear. Phone, tablet, foldable, desktop, ultrawide... every time you think you've handled them all, a new head grows.

Hydra tames the beast. Describe what changes at up to four breakpoints and let it pick the right variant - with zero additional dependencies beyond Flutter itself.

<p align="center">
  <img src="https://raw.githubusercontent.com/igoriuz/hydra/main/.github/demo.gif" width="800" alt="An app built with Hydra adapting its navigation, grid and header while the window is resized from phone to desktop width" />
</p>

<p align="center">
  This is the <a href="example">example app</a>: one widget tree, resized from 390 to 1320 px and back.
  Navigation, header and grid are plain Hydra widgets - including the transitions.
</p>

## Highlights

- **Responsive widgets** - swap entire widgets per breakpoint
- **Animated transitions** - widgets fade, scale or slide in and out instead of jumping
- **Responsive values** - adapt padding, font sizes, colors or any type `T`
- **Building blocks** - visibility, grid and builder widgets for the common cases
- **Configure once** - one `HydraScope` instead of a `behaviour` on every widget
- **Smart fallbacks** - you don't need a variant for every breakpoint
- **Cheap rebuilds** - below a `HydraScope`, widgets rebuild per breakpoint, not per pixel
- **Zero dependencies** - only Flutter SDK, nothing else
- **100% test coverage** - every line, every head

## Installation

```bash
flutter pub add hydra
```

```dart
import 'package:hydra/hydra.dart';
```

## At a glance

| You want to... | Use |
|---|---|
| show a different widget per breakpoint | [`HydraWidget`](#responsive-widgets) |
| pick a value per breakpoint | [`HydraValue<T>` / `context.hydra<T>()`](#responsive-values) |
| build one tree from the breakpoint | [`HydraBuilder` / `Breakpoint.current`](#the-current-breakpoint) |
| show something only on some screens | [`HydraVisibility`](#visibility) |
| change the number of grid columns | [`HydraGrid`](#grid) |
| set breakpoints once for the whole app | [`HydraScope`](#configure-once-with-hydrascope) |

## Responsive Widgets

Use `HydraWidget` to display different widgets based on the current breakpoint:

```dart
const HydraWidget(
  mini: PhoneLayout(),
  medium: TabletLayout(),
  large: DesktopLayout(),
)
```

Hydra selects the best match for the current screen width. If no exact match exists, it falls back to the nearest available alternative - `small` shows `TabletLayout` here.

### Animated transitions

By default the widgets are swapped instantly. Pass a `transition` to animate the change:

```dart
const HydraWidget(
  transition: HydraTransition.fade(),
  mini: PhoneLayout(),
  large: DesktopLayout(),
)
```

| Transition | Effect |
|---|---|
| `HydraTransition.fade()` | Cross-fades the old and the new widget |
| `HydraTransition.scale()` | Fades and scales the new widget in |
| `HydraTransition.size()` | Collapses the old widget and expands the new one along an axis |
| `HydraTransition(builder: ...)` | Your own `AnimatedSwitcher` transition builder |

All of them take a `duration` (300 ms by default), a `curve` and an `alignment` for variants of different size. The same transitions work on [`HydraVisibility`](#visibility).

## Responsive Values

Use the `BuildContext` extension when you need a value instead of a whole widget:

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

Or keep the value around as a `HydraValue<T>` and resolve it later:

```dart
const padding = HydraValue<double>(mini: 8, small: 16, large: 32);

@override
Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(padding.resolve(context)),
    child: content,
  );
}
```

Works with any type - `double`, `EdgeInsets`, `TextStyle`, `Color`, or your own types.

## The Current Breakpoint

`HydraBuilder` hands the active breakpoint to a builder, for a single widget tree that adapts in place:

```dart
HydraBuilder(
  builder: (context, breakpoint) {
    return Padding(
      padding: EdgeInsets.all(breakpoint == Breakpoint.mini ? 8 : 24),
      child: Text('Current: ${breakpoint.name}'),
    );
  },
)
```

Outside of a builder, ask for it directly:

```dart
final breakpoint = Breakpoint.current(context);

if (breakpoint >= Breakpoint.medium) {
  showSideNavigation();
}
```

Breakpoints are ordered from `mini` to `large` and compare with `<`, `<=`, `>` and `>=`.

## Visibility

`HydraVisibility` shows its child only within a range of breakpoints. Both bounds are inclusive and optional; a hidden child is not built.

```dart
// Side navigation on tablets and desktops ...
HydraVisibility(
  visibleFrom: Breakpoint.medium,
  child: const SideNavigation(),
)

// ... and a bottom bar everywhere else.
HydraVisibility(
  visibleUntil: Breakpoint.small,
  child: const BottomBar(),
)
```

Pass a `replacement` to show something else instead of nothing.

With a `transition` the child animates in and out, and the layout around it makes room gradually:

```dart
HydraVisibility(
  visibleFrom: Breakpoint.medium,
  transition: const HydraTransition.size(alignment: Alignment.centerLeft),
  child: const SideNavigation(),
)
```

## Grid

`HydraGrid` is a `GridView.count` whose column count depends on the breakpoint:

```dart
HydraGrid(
  mini: 1,
  small: 2,
  medium: 3,
  large: 4,
  mainAxisSpacing: 16,
  crossAxisSpacing: 16,
  children: cards,
)
```

`padding`, `childAspectRatio`, `shrinkWrap` and `physics` are passed through to the grid.

## Breakpoints

Default breakpoints: **600** (small), **900** (medium), **1200** (large). Everything below 600 is considered `mini`.

```dart
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
```

Every Hydra widget and value accepts a `behaviour`.

### Presets

| Constructor | small / medium / large | Source |
|---|---|---|
| `HydraBehaviour()` | 600 / 900 / 1200 | Hydra default |
| `HydraBehaviour.material()` | 600 / 840 / 1200 | [Material Design 3](https://m3.material.io/foundations/layout/applying-layout) |
| `HydraBehaviour.bootstrap()` | 576 / 768 / 992 | [Bootstrap 5](https://getbootstrap.com/docs/5.3/layout/breakpoints/) `sm` / `md` / `lg` |
| `HydraBehaviour.tailwind()` | 640 / 768 / 1024 | [Tailwind CSS](https://tailwindcss.com/docs/responsive-design) `sm` / `md` / `lg` |
| `HydraBehaviour.cupertino()` | 428 / 768 / 1024 | Apple device widths: iPhone Pro Max (428), iPad portrait, iPad landscape |

### Options

| Constructor | Description |
|---|---|
| `HydraBehaviour()` | Default: orientation-aware, prefers larger fallback |
| `HydraBehaviour.preferSmaller()` | Falls back to smaller alternative instead of larger |
| `HydraBehaviour.noOrientation()` | Uses shortest side regardless of orientation |

By default, Hydra uses `MediaQuery.sizeOf(context).width` which changes when the device rotates. Set `isOrientationAware: false` (or use `HydraBehaviour.noOrientation()`) to use the shortest side instead - the layout stays consistent regardless of rotation. The presets accept both flags as well.

## Configure Once With HydraScope

Instead of passing the same `behaviour` everywhere, put a `HydraScope` above your app:

```dart
HydraScope(
  behaviour: const HydraBehaviour.material(),
  child: MaterialApp(...),
)
```

Everything below it - `HydraWidget`, `HydraValue`, `context.hydra`, `HydraBuilder`, `HydraVisibility`, `HydraGrid` and `Breakpoint.current` - uses the scoped behaviour. A `behaviour` passed directly still wins.

## Performance

Hydra reads the screen size with `MediaQuery.sizeOf`, so it ignores unrelated changes such as the keyboard or text scaling. Two things keep rebuilds down while a window is resized:

- **Use a `HydraScope`.** It resolves the breakpoint once, from the screen size at its place in the tree, and everything below it rebuilds only when the breakpoint changes instead of on every pixel. A `MediaQuery` with a different size below the scope, like a preview frame or a split view, needs a `HydraScope` of its own.
- **`HydraBuilder` rebuilds per breakpoint.** Its builder only runs again when the breakpoint changes, with or without a scope.

For long lists, `HydraGrid.builder` builds its children on demand:

```dart
HydraGrid.builder(
  mini: 2,
  large: 4,
  itemCount: products.length,
  itemBuilder: (context, index) => ProductCard(products[index]),
)
```

`HydraVisibility` removes a hidden child from the tree. Set `maintainState: true` to keep it alive instead - its state survives, and it is not rebuilt from scratch when it comes back.

## How It Works

1. **Breakpoint detection** - determines the current breakpoint from screen width
2. **Exact match** - looks for a widget or value registered at that breakpoint
3. **Nearest fallback** - if no exact match, picks the closest available alternative (prefers larger by default, configurable via `isSmallerScreenPreferred`)

## Example

The [example app](example) is the one from the animation above: a side navigation that slides in, a bottom bar that slides out, a search field that fades in and cards that glide to their new columns. Run it and resize the window:

```bash
cd example
flutter run -d chrome
```

## License

MIT
