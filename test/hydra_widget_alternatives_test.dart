import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';

void main() {
  group('HydraWidget.widgets', () {
    test('lists the biggest breakpoint first by default', () {
      final hydra = HydraWidget(
        mini: const SizedBox(),
        medium: const SizedBox(),
        large: const SizedBox(),
      );

      expect(
        hydra.widgets.map((head) => head.breakpoint),
        [Breakpoint.large, Breakpoint.medium, Breakpoint.mini],
      );
    });

    test('lists the smallest breakpoint first when smaller is preferred', () {
      final hydra = HydraWidget(
        behaviour: const HydraBehaviour.preferSmaller(),
        mini: const SizedBox(),
        small: const SizedBox(),
        large: const SizedBox(),
      );

      expect(
        hydra.widgets.map((head) => head.breakpoint),
        [Breakpoint.mini, Breakpoint.small, Breakpoint.large],
      );
    });
  });
}
