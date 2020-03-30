import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';
import 'package:hydra/src/breakpoint.dart';

void main() {
  group('hydraHead factories', () {
    HydraHead mini, small, medium, large;

    setUpAll(() {
      mini = HydraHead.mini(Container());
      small = HydraHead.small(Container());
      medium = HydraHead.medium(Container());
      large = HydraHead.large(Container());
    });

    group('with breakpoints', () {
      test('mini hydraHead has mini breakpoint', () {
        assert(mini.breakpoint.index == 0);
        expect(mini.breakpoint, isA<Breakpoint>());
        expect(mini.breakpoint, Breakpoint.mini);
        expect(mini.breakpoint.index, Breakpoint.mini.index);
      });

      test('small hydraHead has small breakpoint', () {
        assert(small.breakpoint.index == 1);
        expect(small.breakpoint, isA<Breakpoint>());
        expect(small.breakpoint, Breakpoint.small);
        expect(small.breakpoint.index, Breakpoint.small.index);
      });

      test('medium hydraHead has medium breakpoint', () {
        assert(medium.breakpoint.index == 2);
        expect(medium.breakpoint, isA<Breakpoint>());
        expect(medium.breakpoint, Breakpoint.medium);
        expect(medium.breakpoint.index, Breakpoint.medium.index);
      });

      test('large hydraHead has large breakpoint', () {
        assert(large.breakpoint.index == 3);
        expect(large.breakpoint, isA<Breakpoint>());
        expect(large.breakpoint, Breakpoint.large);
        expect(large.breakpoint.index, Breakpoint.large.index);
      });
    });

    group('ordinal comparison between breakpoints of factories', () {
      test('mini is smaller than small', () {
        assert(mini.breakpoint.index < small.breakpoint.index);
      });

      test('mini is smaller than medium', () {
        assert(mini.breakpoint.index < medium.breakpoint.index);
      });

      test('mini is smaller than large', () {
        assert(mini.breakpoint.index < large.breakpoint.index);
      });

      test('small is smaller than medium', () {
        assert(small.breakpoint.index < medium.breakpoint.index);
      });

      test('small is smaller than large', () {
        assert(small.breakpoint.index < large.breakpoint.index);
      });

      test('medium is smaller than large', () {
        assert(medium.breakpoint.index < large.breakpoint.index);
      });
    });
  });
}
