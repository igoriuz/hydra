// The exception stays tested until it is removed.
// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';

void main() {
  group('HydraNoWidgetException', () {
    test('a HydraWidget without widgets fails an assertion', () {
      expect(
        HydraWidget.new,
        throwsA(isA<AssertionError>()),
      );
    });

    test('a HydraWidget can be const', () {
      // Compiling is the test; widget identity is not checked because
      // flutter test tracks the creation location of every widget.
      const widget = HydraWidget(mini: SizedBox());
      expect(widget.mini, isA<SizedBox>());
    });

    test('has a descriptive toString', () {
      // Not const, so that the constructor runs and counts as covered.
      // ignore: prefer_const_constructors
      final exception = HydraNoWidgetException('test message');
      expect(exception.toString(), 'HydraNoWidgetException: test message');
    });
  });
}
