# Hydra handoff

State as of 2026-11-24. hydra 2.1.0 (tag `v2.1.0`, via the publish workflow) and hydra_test 0.1.0 (first version, published by hand) are **published** on pub.dev.

## Open points

**Needs Igor's accounts**
- pub.dev, package hydra_test, Admin tab: enable automated publishing from GitHub Actions for repository `igoriuz/hydra` with tag pattern `hydra_test-v{{version}}`. Until then a tag `hydra_test-vX.Y.Z` fails in `.github/workflows/publish_hydra_test.yml`; publishing by hand (`cd hydra_test && flutter pub publish`) works, as this Mac now has pub credentials.

**Later on purpose**
- 3.0.0: remove the deprecated `HydraHead`, `HydraWidget.widgets`, `comparableWidth`, `nearestWidget` and `HydraNoWidgetException`; rewrite the fallback tests in `test/hydra_test.dart` that use `nearestWidget` against `HydraResolver`.
- Ideas not built: a fifth breakpoint for ultrawide screens (breaking: exhaustive switches over `Breakpoint`), breakpoints by height.
- hydra_test sets the device pixel ratio of the test view to 1; golden tests that depend on the ratio would see a different one.

## What 2.1.0 contains

See `CHANGELOG.md`: const `HydraWidget`/`HydraValue`, `Breakpoint` comparison operators, `HydraLayoutScope` (breakpoints from the available space, InheritedModel aspects), `HydraSliverGrid`, deprecations, pub.dev listing with screenshots.

## Notes

- `hydra_test/` is a nested package. It is included in the hydra archive like `example/` (pub applies parent ignore files to the nested package, so it cannot be excluded without hiding it from its own publish). Root analysis excludes it; it has its own CI job and tests against the hydra in this repo via `pubspec_overrides.yaml` (not published).
- Tests: `flutter test` at the root (100 % line coverage), `flutter test` in `hydra_test/`.
