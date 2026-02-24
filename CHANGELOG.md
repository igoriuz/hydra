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
