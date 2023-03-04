import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/bases/uint32le.dart';

void main() {
  group('create and serialize Uint32le instance', () {
    test('with vaild value', () {
      const uint32leValue = 0xfffffffe;
      final uint32le = Uint32le(uint32leValue);
      expect(uint32le.value, uint32leValue);
      expect(
        uint32le.serialize(),
        uint32leValue.toUint32leBytes(),
      );
    });

    test('with invalid value', () {
      expect(() => Uint32le(0x100000000), throwsRangeError);
    });
  });

  group('deserialize bytes to Uint32le instance', () {
    test('with valid bytes', () {
      const uint32leValue = 0xfffffffe;
      final serializedPayloadLengthBytes = Uint32le(uint32leValue).serialize();

      expect(
        Uint32le.deserialize(serializedPayloadLengthBytes).value,
        uint32leValue,
      );
    });
    test('with invalid bytes', () {
      expect(
        () => Uint32le.deserialize(
          Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 0xff]),
        ),
        throwsArgumentError,
      );
    });
  });
}
