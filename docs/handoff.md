# Hydra handoff

State as of 2026-11-24. `main` is pushed; 2.1.0 and hydra_test 0.1.0 are built but **not published**.

## Open points

**Igor decides**
- Publish hydra 2.1.0: push tag `v2.1.0` (the publish workflow runs on it). Igor agreed on 2026-11-24; held back until the hydra_test question below is settled.
- Publish hydra_test 0.1.0: the first version of a new package must be published by hand (`cd hydra_test && flutter pub publish`). Afterwards enable automated publishing on pub.dev for tag pattern `hydra_test-v{{version}}`, so later tags `hydra_test-vX.Y.Z` publish via `.github/workflows/publish_hydra_test.yml`.
- Whether hydra_test stays a separate package at all (alternative: drop it and show a copy-paste helper in the README). Decide before tagging `v2.1.0`, as the 2.1.0 README links to hydra_test.

**Later on purpose**
- 3.0.0: remove the deprecated `HydraHead`, `HydraWidget.widgets`, `comparableWidth`, `nearestWidget` and `HydraNoWidgetException`; rewrite the fallback tests in `test/hydra_test.dart` that use `nearestWidget` against `HydraResolver`.
- Ideas not built: a fifth breakpoint for ultrawide screens (breaking: exhaustive switches over `Breakpoint`), breakpoints by height.
- hydra_test sets the device pixel ratio of the test view to 1; golden tests that depend on the ratio would see a different one.

## What 2.1.0 contains

See `CHANGELOG.md`: const `HydraWidget`/`HydraValue`, `Breakpoint` comparison operators, `HydraLayoutScope` (breakpoints from the available space, InheritedModel aspects), `HydraSliverGrid`, deprecations, pub.dev listing with screenshots.

## Notes

- `hydra_test/` is a nested package. It is included in the hydra archive like `example/` (pub applies parent ignore files to the nested package, so it cannot be excluded without hiding it from its own publish). Root analysis excludes it; it has its own CI job and tests against the hydra in this repo via `pubspec_overrides.yaml` (not published).
- Tests: `flutter test` at the root (100 % line coverage), `flutter test` in `hydra_test/`.
