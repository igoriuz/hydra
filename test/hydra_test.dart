import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';
import 'package:hydra/src/breakpoint.dart';

void main() {
  group('HydraWidget', () {
    final mini = Container();
    final small = Container();
    final medium = Container();
    final large = Container();

    group('with only one element in list', () {
      test('returns mini when only mini is available at mini breakpoint', () {
        const screenBP = 15.0;
        final hydra = HydraWidget(mini: mini);

        expect(hydra.widgets.length, 1);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.mini);
      });

      test('returns small when only small is available at large breakpoint',
          () {
        const screenBP = kLargeBP;
        final hydra = HydraWidget(small: small);

        expect(hydra.widgets.length, 1);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.small);
      });

      test('returns medium when only medium is available at small breakpoint',
          () {
        const screenBP = kSmallBP;
        final hydra = HydraWidget(medium: medium);

        expect(hydra.widgets.length, 1);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.medium);
      });

      test('returns large when only large is available at large breakpoint',
          () {
        const screenBP = kLargeBP;
        final hydra = HydraWidget(large: large);

        expect(hydra.widgets.length, 1);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.large);
      });
    });

    group('next bigger screen', () {
      test('small if only [mini, small] at large breakpoint', () {
        const screenBP = kLargeBP;
        final hydra = HydraWidget(mini: mini, small: small);

        expect(hydra.widgets.length, 2);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.small);
      });

      test('large if only [mini, large] at medium breakpoint', () {
        const screenBP = kMediumBP;
        final hydra = HydraWidget(mini: mini, large: large);

        expect(hydra.widgets.length, 2);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.large);
      });

      test('large if only [mini, small, large] at medium breakpoint', () {
        const screenBP = kMediumBP;
        final hydra = HydraWidget(mini: mini, small: small, large: large);

        expect(hydra.widgets.length, 3);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.large);
      });

      test(
          'small if only [mini, small, large] at width between small and medium',
          () {
        const screenBP = kSmallBP + 5;
        final hydra = HydraWidget(mini: mini, small: small, large: large);

        expect(hydra.widgets.length, 3);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.small);
      });
    });

    group('orientation awareness', () {
      test('uses shortestSide when orientation awareness is off (vertical)',
          () {
        const verticalSize = Size(300, 700);
        final hydra = HydraWidget(
          mini: mini,
          behaviour: const HydraBehaviour.noOrientation(),
        );
        expect(hydra.comparableWidth(verticalSize), verticalSize.shortestSide);
      });

      test('uses shortestSide when orientation awareness is off (horizontal)',
          () {
        const horizontalSize = Size(700, 300);
        final hydra = HydraWidget(
          mini: mini,
          behaviour: const HydraBehaviour.noOrientation(),
        );
        expect(
            hydra.comparableWidth(horizontalSize), horizontalSize.shortestSide);
      });

      test('uses shortestSide for vertical device when orientation aware', () {
        const verticalSize = Size(300, 700);
        final hydra = HydraWidget(
          mini: mini,
          behaviour: const HydraBehaviour(isOrientationAware: true),
        );
        expect(hydra.comparableWidth(verticalSize), verticalSize.shortestSide);
      });

      test(
          'uses width (longestSide) for horizontal device when orientation aware',
          () {
        const horizontalSize = Size(700, 300);
        final hydra = HydraWidget(
          mini: mini,
          behaviour: const HydraBehaviour(isOrientationAware: true),
        );
        expect(
            hydra.comparableWidth(horizontalSize), horizontalSize.longestSide);
      });
    });

    group('prefer smaller screen', () {
      test('small if only [mini, small] at large breakpoint', () {
        const screenBP = kLargeBP;
        final hydra = HydraWidget(
          mini: mini,
          small: small,
          behaviour: const HydraBehaviour.preferSmaller(),
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.small);
      });

      test(
          'large if only [mini, large] at medium breakpoint (bigger preferred)',
          () {
        const screenBP = kMediumBP;
        final hydra = HydraWidget(
          mini: mini,
          large: large,
          behaviour: const HydraBehaviour(isSmallerScreenPreferred: false),
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.large);
      });
    });

    group('exact breakpoint match', () {
      test('mini at width 0', () {
        const screenBP = 0.0;
        final hydra = HydraWidget(
          mini: mini,
          small: small,
          behaviour: const HydraBehaviour.preferSmaller(),
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.mini);
      });

      test('medium at medium breakpoint', () {
        const screenBP = kMediumBP;
        final hydra = HydraWidget(
          mini: mini,
          medium: medium,
          large: large,
          behaviour: const HydraBehaviour.preferSmaller(),
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.medium);
      });

      test('small at medium width with smaller preferred', () {
        const screenBP = kMediumBP;
        final hydra = HydraWidget(
          small: small,
          mini: mini,
          large: large,
          behaviour: const HydraBehaviour.preferSmaller(),
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.small);
      });

      test('large at medium width with bigger preferred', () {
        const screenBP = kMediumBP;
        final hydra = HydraWidget(
          small: small,
          mini: mini,
          large: large,
          behaviour: const HydraBehaviour(isSmallerScreenPreferred: false),
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.large);
      });

      test('mini at width 0 with bigger preferred', () {
        const screenBP = 0.0;
        final hydra = HydraWidget(
          small: small,
          mini: mini,
          large: large,
          behaviour: const HydraBehaviour(isSmallerScreenPreferred: false),
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.mini);
      });

      test('medium at large width with smaller preferred', () {
        const screenBP = kLargeBP;
        final hydra = HydraWidget(
          small: small,
          mini: mini,
          medium: medium,
          behaviour: const HydraBehaviour(isSmallerScreenPreferred: true),
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.medium);
      });
    });

    group('material preset', () {
      test('uses Material Design breakpoints', () {
        final hydra = HydraWidget(
          mini: mini,
          small: small,
          medium: medium,
          large: large,
          behaviour: const HydraBehaviour.material(),
        );

        expect(hydra.nearestWidget(0).breakpoint, Breakpoint.mini);
        expect(hydra.nearestWidget(599).breakpoint, Breakpoint.mini);
        expect(hydra.nearestWidget(600).breakpoint, Breakpoint.small);
        expect(hydra.nearestWidget(839).breakpoint, Breakpoint.small);
        expect(hydra.nearestWidget(840).breakpoint, Breakpoint.medium);
        expect(hydra.nearestWidget(1199).breakpoint, Breakpoint.medium);
        expect(hydra.nearestWidget(1200).breakpoint, Breakpoint.large);
      });
    });
  });
}
