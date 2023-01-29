import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/start_height.dart';

void main() {
  group('create and serialize StartHeight instance', () {
    test('with vaild value', () {
      final startHeight = StartHeight(0x7fffffff);
      expect(startHeight.value, 0x7fffffff);
      expect(
        startHeight.serialize(),
        Uint8List.fromList([0xff, 0xff, 0xff, 0x7f]),
      );
    });

    test('with invalid value', () {
      expect(() => StartHeight(0xf0000000), throwsRangeError);
    });
  });
}
