import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/checksum.dart';

void main() {
  group('generate checksum of payload', () {
    test('with hash256 (two times sha256)', () {
      final Uint8List payload = Uint8List.fromList([10, 10, 0]);
      final Uint8List checksum = Uint8List.fromList([112, 193, 27, 119]);

      expect(
        Checksum.fromPayload(payload).bytes,
        checksum,
      );
    });
  });
}
