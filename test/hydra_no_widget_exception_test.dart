import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/hydra.dart';

void main() {
  group('throw exceptions', () {
    final throwsHydraNoWidget = throwsA(isA<HydraNoWidgetException>());

    test('with no widgets given', () {
      expect(() {
        assert(HydraWidget() == null);
      }, throwsHydraNoWidget);
    });
  });
}
