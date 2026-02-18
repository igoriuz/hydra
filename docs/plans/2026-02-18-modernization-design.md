# Hydra Modernization Design

## Context

The Hydra Flutter package (v0.1.0) was created in 2020 and has not been updated since. It targets Dart `>=2.7.0 <3.0.0`, uses the deprecated `pedantic` linter, has no CI/CD, and contains dead code. The goal is to bring it up to current standards and automate publishing to pub.dev.

## Decisions

| Topic | Decision |
|-------|----------|
| SDK constraint | `>=3.5.0 <4.0.0` (Flutter 3.22+) |
| Linting | `flutter_lints` (official Flutter team package) |
| Dead code | Remove `context_behavior_ext.dart` and `hydra_neck.dart` entirely |
| CI triggers | PR checks on `pull_request` + `push` to `main` |
| Publishing | Tag-based (`v*`), reads CHANGELOG.md for release notes |
| Release notes | Extracted from CHANGELOG.md, used for GitHub Release body |
| PR checks | analyze + test + format + coverage + dry-run publish |
| Default branch | Rename `master` → `main` |
| PR strategy | 2 PRs: (1) Cleanup & Modernization, (2) CI/CD |

## PR 1: Cleanup, Modernization & Optimizations

### SDK & Dependencies
- Update `pubspec.yaml` SDK constraint to `sdk: '>=3.5.0 <4.0.0'`
- Update Flutter constraint accordingly (Flutter 3.22+)
- Replace `pedantic` with `flutter_lints` as dev dependency
- Update `analysis_options.yaml` to `include: package:flutter_lints/flutter.yaml`

### Dead Code Removal
- Delete `lib/src/context_behavior_ext.dart` (entirely commented out)
- Delete `lib/src/hydra_neck.dart` (unused generic container)
- Update exports in `lib/hydra.dart`

### Code Modernization
- Ensure full null-safety compliance
- Add `const` constructors where possible
- Use `super` parameters (Dart 3.x feature)
- Consider enhanced enums with properties for `Breakpoint`
- Use switch expressions where applicable
- Propagate widget keys correctly

### Metadata Updates
- Update copyright to 2020-2026
- Update `pubspec.yaml` with topics, screenshots section per current pub.dev standards
- Add/improve dartdoc comments where needed
- Update README if needed

### Branch Rename
- Rename `master` → `main` on GitHub

### Tests
- Update tests for any API changes from modernization
- All tests must pass

### Example App
- Update example `pubspec.yaml` SDK constraints
- Ensure example builds and runs

## PR 2: CI/CD Pipeline

### Workflow 1: `ci.yml` (PR Checks)
- **Triggers**: `pull_request`, `push` to `main`
- **Matrix**: Flutter stable channel
- **Steps**:
  1. Checkout code
  2. Install Flutter SDK (`subosito/flutter-action`)
  3. `flutter pub get`
  4. `dart format --set-exit-if-changed .`
  5. `flutter analyze`
  6. `flutter test --coverage`
  7. Coverage report (lcov)
  8. `dart pub publish --dry-run`

### Workflow 2: `publish.yml` (Tag-based Publishing)
- **Trigger**: Tag push matching `v*`
- **Steps**:
  1. Checkout code
  2. Install Flutter SDK
  3. Validate: tag version matches `pubspec.yaml` version
  4. Run tests (safety check)
  5. Extract CHANGELOG.md section for current version
  6. Create GitHub Release with extracted notes
  7. `dart pub publish --force` (using OIDC credentials via `dart-lang/setup-dart`)

### Dependabot
- `.github/dependabot.yml` for GitHub Actions version updates

## Version Strategy

- PR 1 bumps version to `1.0.0` (breaking change: removed `HydraNeck`, updated SDK constraint)
- CHANGELOG.md updated with all changes
- After merge, tag `v1.0.0` triggers first automated publish
