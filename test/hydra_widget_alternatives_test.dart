// Tests deprecated API until it is removed in 3.0.0.
// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';

void main() {
  group('HydraWidget.widgets', () {
    test('lists the biggest breakpoint first by default', () {
      const hydra = HydraWidget(
        mini: SizedBox(),
        medium: SizedBox(),
        large: SizedBox(),
      );

      expect(
        hydra.widgets.map((head) => head.breakpoint),
        [Breakpoint.large, Breakpoint.medium, Breakpoint.mini],
      );
    });

    test('lists the smallest breakpoint first when smaller is preferred', () {
      const hydra = HydraWidget(
        behaviour: HydraBehaviour.preferSmaller(),
        mini: SizedBox(),
        small: SizedBox(),
        large: SizedBox(),
      );

      expect(
        hydra.widgets.map((head) => head.breakpoint),
        [Breakpoint.mini, Breakpoint.small, Breakpoint.large],
      );
    });
  });
}
