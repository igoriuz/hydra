# README Redesign & Breakpoint Presets Design

## Context

The README is minimal and missing key pub.dev conventions (installation, code examples, badges). Default breakpoints (90/400/800) are unusual. The `Breakpoint` enum is not publicly exported.

## Decisions

| Topic | Decision |
|-------|----------|
| README style | Pub.dev standard with badges, installation, code examples |
| Default breakpoints | Change to 600/900/1200 |
| Material preset | Add `HydraBehaviour.material()` with 600/840/1200 |
| Breakpoint export | Export `Breakpoint` enum publicly |
| Version | Bump to 1.1.0 |

## README Structure

1. Logo + title + one-liner
2. Badges: pub.dev version, CI status, license
3. Installation: `flutter pub add hydra`
4. Quick Start: minimal HydraWidget code example
5. Behaviour: breakpoints explanation, named constructors, presets
6. How it works: bullet points (breakpoint selection, fallback, orientation)
7. API Reference: link to pub.dev dartdoc

## Code Changes

1. Export `Breakpoint` in `lib/hydra.dart`
2. Update defaults: `kSmallBP=600`, `kMediumBP=900`, `kLargeBP=1200`
3. Add `HydraBehaviour.material()` named constructor with 600/840/1200
4. Update tests for new defaults
5. Update CHANGELOG for 1.1.0
