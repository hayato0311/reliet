import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/payload_length.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/utils/encode.dart';

void main() {
  group('create and serialize StartHeight instance', () {
    test('with vaild value', () {
      const payloadLengthValue = 0xfffffffe;
      final payloadLength = PayloadLength(payloadLengthValue);
      expect(payloadLength.value, payloadLengthValue);
      expect(
        payloadLength.serialize(),
        uint32leBytes(payloadLengthValue),
      );
    });

    test('with invalid value', () {
      expect(() => PayloadLength(0x100000000), throwsRangeError);
    });
  });
}
