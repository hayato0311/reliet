import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/payload_length.dart';

void main() {
  group('create and serialize StartHeight instance', () {
    test('with vaild value', () {
      const payloadLengthValue = 0xfffffffe;
      final payloadLength = PayloadLength(payloadLengthValue);
      expect(payloadLength.value, payloadLengthValue);
      expect(
        payloadLength.serialize(),
        payloadLengthValue.toUint32leBytes(),
      );
    });

    test('with invalid value', () {
      expect(() => PayloadLength(0x100000000), throwsRangeError);
    });
  });
}
