import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/payload_length.dart';

void main() {
  group('create and serialize StartHeight instance', () {
    test('with vaild value', () {
      final payloadLength = PayloadLength(0xffffffff);
      expect(payloadLength.value, 0xffffffff);
      expect(
        payloadLength.serialize(),
        Uint8List.fromList([0xff, 0xff, 0xff, 0xff]),
      );
    });

    test('with invalid value', () {
      expect(() => PayloadLength(0x100000000), throwsRangeError);
    });
  });
}
