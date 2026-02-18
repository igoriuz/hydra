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
