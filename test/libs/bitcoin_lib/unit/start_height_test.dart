import 'dart:typed_data';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/start_height.dart';

void main() {
  group('create and serialize StartHeight instance', () {
    test('with vaild value', () {
      final StartHeight startHeight = StartHeight(pow(2, 31) - 1 as int);
      expect(startHeight.value, pow(2, 31) - 1 as int);
      expect(
        startHeight.serialize(),
        Uint8List.fromList([0xff, 0xff, 0xff, 0x7f]),
      );
    });

    test('with invalid value', () {
      expect(() => StartHeight(pow(2, 31) as int), throwsRangeError);
    });
  });
}
