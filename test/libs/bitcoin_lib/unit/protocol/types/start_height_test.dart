import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/start_height.dart';

void main() {
  group('create and serialize StartHeight instance', () {
    test('with vaild value', () {
      const startHeightValue = 0x7fffffff;
      final startHeight = StartHeight(startHeightValue);
      expect(startHeight.value, startHeightValue);
      expect(
        startHeight.serialize(),
        startHeightValue.toInt32leBytes(),
      );
    });

    test('with invalid value', () {
      expect(() => StartHeight(0xf0000000), throwsRangeError);
    });
  });

  group('deserialize bytes to StartHeight instance', () {
    test('with valid bytes', () {
      const startHeightValue = 0x7fffffff;
      final serializedStartHeightBytes =
          StartHeight(startHeightValue).serialize();

      expect(
        StartHeight.deserialize(serializedStartHeightBytes).value,
        startHeightValue,
      );
    });

    test('with invalid bytes', () {
      expect(
        () => StartHeight.deserialize(
          Uint8List.fromList([0, 0]),
        ),
        throwsArgumentError,
      );
    });
  });
}
