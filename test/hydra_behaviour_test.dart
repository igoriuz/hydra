import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';

void main() {
  group('HydraBehaviour', () {
    group('default constructor', () {
      test('has correct default values', () {
        // ignore: prefer_const_constructors
        final behaviour = HydraBehaviour();

        expect(behaviour.breakpointSmall, kSmallBP);
        expect(behaviour.breakpointMedium, kMediumBP);
        expect(behaviour.breakpointLarge, kLargeBP);
        expect(behaviour.isOrientationAware, isTrue);
        expect(behaviour.isSmallerScreenPreferred, isFalse);
      });

      test('accepts custom breakpoints', () {
        // ignore: prefer_const_constructors
        final behaviour = HydraBehaviour(
          breakpointSmall: 400,
          breakpointMedium: 800,
          breakpointLarge: 1000,
        );

        expect(behaviour.breakpointSmall, 400);
        expect(behaviour.breakpointMedium, 800);
        expect(behaviour.breakpointLarge, 1000);
      });

      test('asserts when breakpointSmall >= breakpointMedium', () {
        expect(
          // ignore: prefer_const_constructors
          () => HydraBehaviour(breakpointSmall: 900, breakpointMedium: 900),
          throwsA(isA<AssertionError>()),
        );
      });

      test('asserts when breakpointMedium >= breakpointLarge', () {
        expect(
          // ignore: prefer_const_constructors
          () => HydraBehaviour(breakpointMedium: 1200, breakpointLarge: 1200),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('preferSmaller', () {
      test('has isSmallerScreenPreferred set to true', () {
        // ignore: prefer_const_constructors
        final behaviour = HydraBehaviour.preferSmaller();

        expect(behaviour.isSmallerScreenPreferred, isTrue);
        expect(behaviour.breakpointSmall, kSmallBP);
        expect(behaviour.breakpointMedium, kMediumBP);
        expect(behaviour.breakpointLarge, kLargeBP);
        expect(behaviour.isOrientationAware, isTrue);
      });

      test('accepts custom breakpoints', () {
        // ignore: prefer_const_constructors
        final behaviour = HydraBehaviour.preferSmaller(
          breakpointSmall: 500,
          breakpointMedium: 700,
          breakpointLarge: 1100,
        );

        expect(behaviour.breakpointSmall, 500);
        expect(behaviour.breakpointMedium, 700);
        expect(behaviour.breakpointLarge, 1100);
      });

      test('asserts when breakpointSmall >= breakpointMedium', () {
        expect(
          () => HydraBehaviour.preferSmaller(
            breakpointSmall: 900,
            breakpointMedium: 900,
          ),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('noOrientation', () {
      test('has isOrientationAware set to false', () {
        // ignore: prefer_const_constructors
        final behaviour = HydraBehaviour.noOrientation();

        expect(behaviour.isOrientationAware, isFalse);
        expect(behaviour.breakpointSmall, kSmallBP);
        expect(behaviour.breakpointMedium, kMediumBP);
        expect(behaviour.breakpointLarge, kLargeBP);
        expect(behaviour.isSmallerScreenPreferred, isFalse);
      });

      test('accepts custom breakpoints', () {
        // ignore: prefer_const_constructors
        final behaviour = HydraBehaviour.noOrientation(
          breakpointSmall: 450,
          breakpointMedium: 850,
          breakpointLarge: 1050,
        );

        expect(behaviour.breakpointSmall, 450);
        expect(behaviour.breakpointMedium, 850);
        expect(behaviour.breakpointLarge, 1050);
      });

      test('asserts when breakpointMedium >= breakpointLarge', () {
        expect(
          () => HydraBehaviour.noOrientation(
            breakpointMedium: 1200,
            breakpointLarge: 1200,
          ),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('material', () {
      test('uses Material Design breakpoints', () {
        // ignore: prefer_const_constructors
        final behaviour = HydraBehaviour.material();

        expect(behaviour.breakpointSmall, 600);
        expect(behaviour.breakpointMedium, 840);
        expect(behaviour.breakpointLarge, 1200);
        expect(behaviour.isOrientationAware, isTrue);
        expect(behaviour.isSmallerScreenPreferred, isFalse);
      });

      test('accepts custom flags', () {
        // ignore: prefer_const_constructors
        final behaviour = HydraBehaviour.material(
          isOrientationAware: false,
          isSmallerScreenPreferred: true,
        );

        expect(behaviour.isOrientationAware, isFalse);
        expect(behaviour.isSmallerScreenPreferred, isTrue);
      });
    });
  });
}
