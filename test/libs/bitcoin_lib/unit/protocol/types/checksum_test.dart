import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/checksum.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/hash256.dart';

void main() {
  group('generate checksum of payload', () {
    test('with hash256 (two times sha256)', () {
      final payload = Uint8List.fromList([10, 10, 0]);
      final checksum = Hash256.create(payload).bytes.sublist(0, 4);

      expect(
        Checksum.fromPayload(payload).bytes,
        checksum,
      );
    });
  });

  group('validate given checksum bytes', () {
    test('with valid value', () {
      final payload = Uint8List.fromList([10, 10, 0]);
      final correctChecksum =
          Uint8List.fromList(Hash256.create(payload).bytes.sublist(0, 4));

      expect(
        Checksum.fromPayload(payload).isValid(correctChecksum),
        true,
      );
    });
    test('with invalid value', () {
      final payload = Uint8List.fromList([10, 10, 0]);
      final incorrectChecksum = Uint8List.fromList([1, 2, 3, 4]);

      expect(
        Checksum.fromPayload(payload).isValid(incorrectChecksum),
        false,
      );
    });
  });
}
