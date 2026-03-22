import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/src/breakpoint.dart';
import 'package:hydra/src/hydra_behaviour.dart';
import 'package:hydra/src/hydra_resolver.dart';

void main() {
  group('HydraResolver', () {
    group('comparableWidth', () {
      test('returns width when orientation-aware and landscape', () {
        const resolver = HydraResolver();
        const size = Size(700, 300);
        expect(resolver.comparableWidth(size), 700);
      });

      test('returns width when orientation-aware and portrait', () {
        const resolver = HydraResolver();
        const size = Size(300, 700);
        expect(resolver.comparableWidth(size), 300);
      });

      test('returns shortestSide when not orientation-aware (landscape)', () {
        const resolver = HydraResolver(
          behaviour: HydraBehaviour.noOrientation(),
        );
        const size = Size(700, 300);
        expect(resolver.comparableWidth(size), 300);
      });

      test('returns shortestSide when not orientation-aware (portrait)', () {
        const resolver = HydraResolver(
          behaviour: HydraBehaviour.noOrientation(),
        );
        const size = Size(300, 700);
        expect(resolver.comparableWidth(size), 300);
      });
    });

    group('resolveBreakpoint', () {
      test('returns mini for width below small breakpoint', () {
        const resolver = HydraResolver();
        expect(resolver.resolveBreakpoint(0), Breakpoint.mini);
        expect(resolver.resolveBreakpoint(599), Breakpoint.mini);
      });

      test('returns small for width at small breakpoint', () {
        const resolver = HydraResolver();
        expect(resolver.resolveBreakpoint(kSmallBP), Breakpoint.small);
      });

      test('returns medium for width at medium breakpoint', () {
        const resolver = HydraResolver();
        expect(resolver.resolveBreakpoint(kMediumBP), Breakpoint.medium);
      });

      test('returns large for width at large breakpoint', () {
        const resolver = HydraResolver();
        expect(resolver.resolveBreakpoint(kLargeBP), Breakpoint.large);
      });

      test('uses material breakpoints', () {
        const resolver = HydraResolver(
          behaviour: HydraBehaviour.material(),
        );
        expect(resolver.resolveBreakpoint(599), Breakpoint.mini);
        expect(resolver.resolveBreakpoint(600), Breakpoint.small);
        expect(resolver.resolveBreakpoint(839), Breakpoint.small);
        expect(resolver.resolveBreakpoint(840), Breakpoint.medium);
        expect(resolver.resolveBreakpoint(1199), Breakpoint.medium);
        expect(resolver.resolveBreakpoint(1200), Breakpoint.large);
      });
    });

    group('resolveValue', () {
      test('returns exact match at each breakpoint', () {
        const resolver = HydraResolver();
        expect(
          resolver.resolveValue<String>(
            0,
            mini: 'a',
            small: 'b',
            medium: 'c',
            large: 'd',
          ),
          'a',
        );
        expect(
          resolver.resolveValue<String>(
            kSmallBP,
            mini: 'a',
            small: 'b',
            medium: 'c',
            large: 'd',
          ),
          'b',
        );
        expect(
          resolver.resolveValue<String>(
            kMediumBP,
            mini: 'a',
            small: 'b',
            medium: 'c',
            large: 'd',
          ),
          'c',
        );
        expect(
          resolver.resolveValue<String>(
            kLargeBP,
            mini: 'a',
            small: 'b',
            medium: 'c',
            large: 'd',
          ),
          'd',
        );
      });

      test('returns only value when just one provided', () {
        const resolver = HydraResolver();
        expect(
          resolver.resolveValue<String>(kLargeBP, small: 'only'),
          'only',
        );
        expect(
          resolver.resolveValue<String>(0, large: 'only'),
          'only',
        );
      });

      test('prefers larger when equidistant (default)', () {
        const resolver = HydraResolver();
        // medium breakpoint, only small and large → prefers large
        expect(
          resolver.resolveValue<String>(
            kMediumBP,
            small: 's',
            large: 'l',
          ),
          'l',
        );
      });

      test('prefers smaller when equidistant with preferSmaller', () {
        const resolver = HydraResolver(
          behaviour: HydraBehaviour.preferSmaller(),
        );
        // medium breakpoint, only small and large → prefers small
        expect(
          resolver.resolveValue<String>(
            kMediumBP,
            small: 's',
            large: 'l',
          ),
          's',
        );
      });

      test('falls back to nearest available value', () {
        const resolver = HydraResolver();
        // large breakpoint, only mini and small → nearest is small
        expect(
          resolver.resolveValue<String>(
            kLargeBP,
            mini: 'm',
            small: 's',
          ),
          's',
        );
      });
    });
  });
}
