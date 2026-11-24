// Tests deprecated API until it is removed in 3.0.0.
// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';

void main() {
  group('HydraHead factories', () {
    final mini = HydraHead.mini(Container());
    final small = HydraHead.small(Container());
    final medium = HydraHead.medium(Container());
    final large = HydraHead.large(Container());

    group('breakpoint assignment', () {
      test('mini has Breakpoint.mini', () {
        expect(mini.breakpoint, Breakpoint.mini);
        expect(mini.breakpoint.index, 0);
      });

      test('small has Breakpoint.small', () {
        expect(small.breakpoint, Breakpoint.small);
        expect(small.breakpoint.index, 1);
      });

      test('medium has Breakpoint.medium', () {
        expect(medium.breakpoint, Breakpoint.medium);
        expect(medium.breakpoint.index, 2);
      });

      test('large has Breakpoint.large', () {
        expect(large.breakpoint, Breakpoint.large);
        expect(large.breakpoint.index, 3);
      });
    });

    group('ordinal comparison', () {
      test('mini < small < medium < large', () {
        expect(mini.breakpoint.index, lessThan(small.breakpoint.index));
        expect(small.breakpoint.index, lessThan(medium.breakpoint.index));
        expect(medium.breakpoint.index, lessThan(large.breakpoint.index));
      });
    });
  });
}
