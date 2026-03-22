import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/src/hydra_no_value_exception.dart';

void main() {
  group('HydraNoValueException', () {
    test('has a descriptive toString', () {
      const exception = HydraNoValueException('test message');
      expect(exception.toString(), 'HydraNoValueException: test message');
    });

    test('is an Exception', () {
      const exception = HydraNoValueException('msg');
      expect(exception, isA<Exception>());
    });
  });
}
