import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';
import 'package:hydra/src/breakpoint.dart';

void main() {
  group('testing hydraWidget', () {
    Widget mini, small, medium, large;
    HydraBehaviour multiScreenBehaviour;
    var screenBP = 0.0;

    setUpAll(() {
      mini = Container();
      small = Container();
      medium = Container();
      large = Container();
    });

    group('with only one element in list', () {
      test(
          'returns mini if only [mini] is available and meets the mini breakpoint range',
          () {
        screenBP = 15;
        var hydra = HydraWidget(
          mini: mini,
        );

        assert(hydra.widgets.length == 1);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.mini);
      });

      test(
          'returns small if only [small] is available while breakpoint is large',
          () {
        screenBP = kLargeBP;
        var hydra = HydraWidget(
          small: small,
        );

        assert(hydra.widgets.length == 1);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.small);
      });

      test(
          'returns medium if only [medium] is available while breakpoint is small',
          () {
        screenBP = kSmallBP;
        var hydra = HydraWidget(
          medium: medium,
        );

        assert(hydra.widgets.length == 1);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.medium);
      });

      test(
          'returns large if only [large] is available while breakpoint is large',
          () {
        screenBP = kLargeBP;
        var hydra = HydraWidget(
          large: large,
        );

        assert(hydra.widgets.length == 1);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.large);
      });
    });

    group('next bigger screen', () {
      test('small if only [mini, small] is available with breakpoint large',
          () {
        screenBP = kLargeBP;
        var hydra = HydraWidget(
          mini: mini,
          small: small,
        );

        assert(hydra.widgets.length == 2);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.small);
      });

      test('large if only [mini, large] is available with breakpoint medium',
          () {
        screenBP = kMediumBP;
        var hydra = HydraWidget(
          mini: mini,
          large: large,
        );

        assert(hydra.widgets.length == 2);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.large);
      });

      test(
          'large if only [mini, small, large] is available with breakpoint medium',
          () {
        screenBP = kMediumBP;
        var hydra = HydraWidget(
          mini: mini,
          small: small,
          large: large,
        );

        assert(hydra.widgets.length == 3);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.large);
      });

      test(
          'small if only [mini, small, large] is available with width between small and medium',
          () {
        screenBP = kSmallBP + 5; // range between small and medium
        var hydra = HydraWidget(
          mini: mini,
          small: small,
          large: large,
        );

        assert(hydra.widgets.length == 3);
        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.small);
      });
    });

    group('test preferred screen attribute', () {
      Size verticalSize;
      Size horizontalSize;

      setUpAll(() {
        verticalSize = Size(300, 700);
        horizontalSize = Size(700, 300);
      });

      test(
          'shortest width if orientation awarness is not relevant with vertical device',
          () {
        multiScreenBehaviour = HydraBehaviour.noOrientation();
        var hydra = HydraWidget(
          mini: mini,
          behaviour: multiScreenBehaviour,
        );
        expect(hydra.comparableWidth(verticalSize), verticalSize.shortestSide);
      });

      test(
          'shortest width if orientation awarness is not relevant with horizontal device',
          () {
        multiScreenBehaviour = HydraBehaviour.noOrientation();
        var hydra = HydraWidget(
          mini: mini,
          behaviour: multiScreenBehaviour,
        );
        expect(
            hydra.comparableWidth(horizontalSize), horizontalSize.shortestSide);
      });

      test('current width is shortestSide if orientation awarness is relevant',
          () {
        multiScreenBehaviour = HydraBehaviour(isOrientationAware: true);
        var hydra = HydraWidget(
          mini: mini,
          behaviour: multiScreenBehaviour,
        );
        expect(hydra.comparableWidth(verticalSize), verticalSize.shortestSide);
      });

      test('current width is longestSide if orientation awarness is relevant',
          () {
        multiScreenBehaviour = HydraBehaviour(isOrientationAware: true);
        var hydra = HydraWidget(
          mini: mini,
          behaviour: multiScreenBehaviour,
        );
        expect(
            hydra.comparableWidth(horizontalSize), horizontalSize.longestSide);
      });
    });

    group('next smaller screen', () {
      setUpAll(() {
        multiScreenBehaviour = HydraBehaviour.preferSmaller();
      });

      test('small if only [mini, small] is available', () {
        screenBP = kLargeBP;
        var hydra = HydraWidget(
          mini: mini,
          small: small,
          behaviour: multiScreenBehaviour,
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.small);
      });

      test('large if only [mini, large] is available', () {
        multiScreenBehaviour = HydraBehaviour(isSmallerScreenPreferred: false);
        screenBP = kMediumBP;
        var hydra = HydraWidget(
          mini: mini,
          large: large,
          behaviour: multiScreenBehaviour,
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.large);
      });
    });

    group('same screen size', () {
      setUpAll(() {
        multiScreenBehaviour = HydraBehaviour.preferSmaller();
      });

      test('small if only [mini, small] is available', () {
        screenBP = 0;
        var hydra = HydraWidget(
          mini: mini,
          small: small,
          behaviour: multiScreenBehaviour,
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.mini);
      });

      test('medium if [mini, medium, large] is available', () {
        screenBP = kMediumBP;
        var hydra = HydraWidget(
          mini: mini,
          medium: medium,
          large: large,
          behaviour: multiScreenBehaviour,
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.medium);
      });

      test(
          'small if only [small, mini, large] with medium size and smaller screen preferred',
          () {
        screenBP = kMediumBP;
        multiScreenBehaviour = HydraBehaviour.preferSmaller();
        var hydra = HydraWidget(
          small: small,
          mini: mini,
          large: large,
          behaviour: multiScreenBehaviour,
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.small);
      });

      test(
          'large if only [small, mini, large] with medium size and bigger screen preferred',
          () {
        multiScreenBehaviour = HydraBehaviour(isSmallerScreenPreferred: false);
        screenBP = kMediumBP;
        var hydra = HydraWidget(
          small: small,
          mini: mini,
          large: large,
          behaviour: multiScreenBehaviour,
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.large);
      });

      test(
          'large if only [small, mini, large] with medium size and bigger screen preferred',
          () {
        multiScreenBehaviour = HydraBehaviour(isSmallerScreenPreferred: false);
        screenBP = 0;
        var hydra = HydraWidget(
          small: small,
          mini: mini,
          large: large,
          behaviour: multiScreenBehaviour,
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.mini);
      });

      test(
          'large if only [small, mini, large] with medium size and bigger screen preferred',
          () {
        multiScreenBehaviour = HydraBehaviour(isSmallerScreenPreferred: true);
        screenBP = kLargeBP;
        var hydra = HydraWidget(
          small: small,
          mini: mini,
          medium: medium,
          behaviour: multiScreenBehaviour,
        );

        expect(hydra.nearestWidget(screenBP).breakpoint, Breakpoint.medium);
      });
    });
  });
}
