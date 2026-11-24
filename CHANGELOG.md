# 2.1.0

* `HydraWidget` and `HydraValue` have `const` constructors. Without any alternative they now fail an assertion in debug builds instead of throwing `HydraNoWidgetException` / `HydraNoValueException` from the constructor; in release builds resolving throws `HydraNoValueException`
* `HydraNoWidgetException` is deprecated, as nothing throws it anymore
* Deprecated `HydraHead`, `HydraWidget.widgets`, `HydraWidget.comparableWidth` and `HydraWidget.nearestWidget`: they ignore `HydraScope` and `HydraLayoutScope`. Use `Breakpoint.current`, `HydraResolver` or the `mini` … `large` fields instead; all of them will be removed in 3.0.0
* `context.hydra<T>()` without any value throws `HydraNoValueException` as before
* Added `HydraLayoutScope` to resolve the breakpoint from the available space instead of the screen, like a CSS container query
* Added `HydraSliverGrid` and `HydraSliverGrid.builder`, the sliver of `HydraGrid` for a `CustomScrollView`
* `Breakpoint` compares with `<`, `<=`, `>` and `>=`
* New pub.dev description, the `adaptive` topic and screenshots of the example app

# 2.0.1

* `HydraBuilder` runs its builder only when the breakpoint changes, not on every change of the screen size
* `HydraScope` resolves the breakpoint once, from the screen size at its place in the tree; widgets and values below it rebuild only when the breakpoint changes. A `MediaQuery` with a different size below a scope needs a `HydraScope` of its own
* `HydraScope` is now a `StatelessWidget`; `HydraScope.of(context)` is unchanged, `HydraScope.breakpointOf(context)` is new
* Added `HydraGrid.builder` for lazily built grids
* Added `maintainState` to `HydraVisibility` to keep a hidden child alive
* Added `HydraResolver.resolveValueAt` to resolve by breakpoint instead of width

# 2.0.0

* **Breaking:** `behaviour` of `HydraWidget`, `HydraValue` and `context.hydra<T>()` is now optional and falls back to the nearest `HydraScope`. The `behaviour` fields are nullable as a result - code reading e.g. `widget.behaviour.breakpointSmall` needs a null check
* **Breaking:** `HydraWidget.widgets` is now a getter; the alternatives are available as `mini`, `small`, `medium` and `large`
* Added `HydraScope` to configure the behaviour once for a whole subtree
* Added `HydraBuilder` to build one widget tree from the current breakpoint
* Added `Breakpoint.current(context)` for direct access to the active breakpoint
* Added `HydraVisibility` to show a widget only within a range of breakpoints
* Added `HydraGrid`, a grid with a column count per breakpoint
* Added `HydraTransition` (`fade`, `scale`, `size` or a custom builder) and the `transition` parameter of `HydraWidget` and `HydraVisibility` for animated breakpoint changes
* Added `HydraBehaviour.bootstrap()`, `HydraBehaviour.tailwind()` and `HydraBehaviour.cupertino()` presets
* `HydraBehaviour` now has value equality
* `HydraTransition` takes an `alignment` for variants of different size
* `HydraResolver.of(context)` resolves the scoped behaviour; `resolveValue` throws `HydraNoValueException` without any value
* New showcase example app and README animation; the example uses `package:material_ui`

# 1.2.0

* Added `HydraValue<T>` for responsive values without widgets
* Added `context.hydra<T>()` extension for inline responsive values
* Added `HydraResolver` with shared breakpoint resolution logic
* Refactored `HydraWidget` to use `HydraResolver` internally (no breaking changes)
* Updated README with new features and code examples

# 1.1.4

* Use `MediaQuery.sizeOf` instead of `MediaQuery.of` to reduce unnecessary rebuilds
* Migrated from `flutter_lints` to `very_good_analysis` for stricter linting
* Added `HydraBehaviour` unit tests for full Codecov coverage

# 1.1.3

* Added Codecov integration for test coverage reporting
* Achieved 100% test coverage with widget build test
* Improved README with Hydra mythology intro and "Why Hydra?" section

# 1.1.2

* Removed `dartdoc_options.yaml` that referenced unnamed library, fixing pub.dev doc generation
* Fixed dartdoc warnings by qualifying field references in `{@macro}` template
* Added `build/` and `doc/` to `.pubignore`

# 1.1.1

* Fixed `dartdoc_options.yaml` syntax causing pub.dev documentation generation to fail

# 1.1.0

* **Breaking:** Default breakpoints changed from 90/400/800 to 600/900/1200
* Added `HydraBehaviour.material()` preset with Material Design breakpoints (600/840/1200)
* Exported `Breakpoint` enum as public API
* Rewrote README with installation guide, code examples, and badges

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
