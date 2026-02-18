import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';

void main() {
  group('HydraNoWidgetException', () {
    test('throws when no widgets are given', () {
      expect(
        () => HydraWidget(),
        throwsA(isA<HydraNoWidgetException>()),
      );
    });

    test('has a descriptive toString', () {
      const exception = HydraNoWidgetException('test message');
      expect(exception.toString(), 'HydraNoWidgetException: test message');
    });
  });
}
