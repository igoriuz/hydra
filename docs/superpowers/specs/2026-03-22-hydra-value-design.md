# HydraValue<T> — Responsive Values Without Widgets

**Date:** 2026-03-22
**Status:** Approved

## Problem

Hydra currently only supports responsive **widgets** via `HydraWidget`. Often developers need responsive **values** (padding, font size, colors, etc.) that change based on breakpoints — without building separate widgets for each.

## Solution

Add `HydraValue<T>` — a generic class that resolves a value based on the current screen breakpoint, reusing the same breakpoint logic as `HydraWidget`.

## Architecture

### HydraResolver (shared breakpoint logic)

Extract breakpoint resolution from `HydraWidget` into a standalone class. Owns **all** resolution logic including fallback/nearest-match, so neither `HydraWidget` nor `HydraValue` duplicate it.

```dart
class HydraResolver {
  const HydraResolver({this.behaviour = const HydraBehaviour()});

  final HydraBehaviour behaviour;

  /// Returns `size.width` when orientation-aware, or `size.shortestSide` when not.
  double comparableWidth(Size size);

  /// Maps a screen width to a Breakpoint enum value.
  Breakpoint resolveBreakpoint(double width);

  /// Resolves the best value from four nullable candidates for the given width.
  /// Uses nearest-breakpoint fallback, respecting `isSmallerScreenPreferred`.
  T resolveValue<T>(double width, {T? mini, T? small, T? medium, T? large});
}
```

- `HydraWidget` is refactored to use `HydraResolver` internally.
- No breaking changes to the public API of `HydraWidget`.
- `resolveValue<T>` encapsulates the fallback/nearest-match logic (currently in `_closestAlternative`) so both `HydraWidget` and `HydraValue` share it without duplication.

### HydraValue<T>

```dart
class HydraValue<T> {
  HydraValue({
    T? mini,
    T? small,
    T? medium,
    T? large,
    this.behaviour = const HydraBehaviour(),
  });

  /// Resolves the value for the current screen size.
  T resolve(BuildContext context);
}
```

- **Not const** — validation happens eagerly in the constructor (matching `HydraWidget` pattern). Throws `HydraNoValueException` if all values are null.
- Uses `HydraResolver` + `MediaQuery.sizeOf(context)` for breakpoint detection.
- Delegates fallback logic entirely to `HydraResolver.resolveValue<T>`.

### HydraContext Extension

```dart
extension HydraContext on BuildContext {
  T hydra<T>({
    T? mini,
    T? small,
    T? medium,
    T? large,
    HydraBehaviour? behaviour,
  });
}
```

- Convenience shortcut — creates a `HydraValue<T>` internally and calls `resolve(this)`.
- `behaviour` defaults to `const HydraBehaviour()`.
- Method named `hydra<T>` for brevity and clarity (returns the resolved `T`, not a `HydraValue`).

### Error Handling

- Introduce `HydraNoValueException` for `HydraValue` (analogous to `HydraNoWidgetException`).
- Keep `HydraNoWidgetException` as-is to avoid breaking changes.

## File Changes

| File | Action |
|---|---|
| `lib/src/hydra_resolver.dart` | New — shared breakpoint resolution incl. fallback |
| `lib/src/hydra_value.dart` | New — `HydraValue<T>` class |
| `lib/src/hydra_context.dart` | New — `HydraContext` extension |
| `lib/src/hydra_no_value_exception.dart` | New — exception class |
| `lib/src/hydra_widget.dart` | Refactor — delegate to `HydraResolver` |
| `lib/hydra.dart` | Add exports |
| `test/hydra_resolver_test.dart` | New — tests for resolver |
| `test/hydra_value_test.dart` | New — tests for HydraValue |
| `test/hydra_context_test.dart` | New — tests for extension |
| `test/hydra_no_value_exception_test.dart` | New — tests for exception |
| `test/hydra_test.dart` | Verify no regressions after refactor |

## Key Test Scenarios

- All four values provided, exact match at each breakpoint
- Only one value provided — every breakpoint resolves to it
- Two equidistant values with `isSmallerScreenPreferred` true vs false
- Orientation-aware vs not (width vs shortestSide)
- Extension method delegates correctly to `HydraValue.resolve`
- `HydraNoValueException` thrown when no values provided
- `HydraWidget` existing tests pass unchanged after refactor

## Constraints

- Zero new dependencies
- 100% test coverage maintained
- All existing tests must pass unchanged
- Non-const constructor for `HydraValue` (eager validation, matching `HydraWidget`)
- `HydraResolver` is const (only holds `HydraBehaviour`)
