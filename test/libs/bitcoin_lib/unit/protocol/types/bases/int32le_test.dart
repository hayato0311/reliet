import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/bases/int32le.dart';

void main() {
  group('create and serialize Int32le instance', () {
    test('with vaild value', () {
      const int32leValue = 0x7fffffff;
      final int32le = Int32le(int32leValue);
      expect(int32le.value, int32leValue);
      expect(
        int32le.serialize(),
        int32leValue.toInt32leBytes(),
      );
    });

    test('with invalid value', () {
      expect(() => Int32le(0xf0000000), throwsRangeError);
    });
  });

  group('deserialize bytes to Int32le instance', () {
    test('with valid bytes', () {
      const int32leValue = 0x7fffffff;
      final serializedInt32leBytes = Int32le(int32leValue).serialize();

      expect(
        Int32le.deserialize(serializedInt32leBytes).value,
        int32leValue,
      );
    });

    test('with invalid bytes', () {
      expect(
        () => Int32le.deserialize(
          Uint8List.fromList([0, 0]),
        ),
        throwsArgumentError,
      );
    });
  });
}
