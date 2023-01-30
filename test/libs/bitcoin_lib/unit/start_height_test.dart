import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/start_height.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/utils/encode.dart';

void main() {
  group('create and serialize StartHeight instance', () {
    test('with vaild value', () {
      const startHeightValue = 0x7fffffff;
      final startHeight = StartHeight(startHeightValue);
      expect(startHeight.value, startHeightValue);
      expect(
        startHeight.serialize(),
        int32leBytes(startHeightValue),
      );
    });

    test('with invalid value', () {
      expect(() => StartHeight(0xf0000000), throwsRangeError);
    });
  });
}
