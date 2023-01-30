import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/bool_extensions.dart';

void main() {
  group('convert boolean into integer', () {
    test('when true', () {
      expect(true.toInt(), 1);
    });
    test('when false', () {
      expect(false.toInt(), 0);
    });
  });
}
