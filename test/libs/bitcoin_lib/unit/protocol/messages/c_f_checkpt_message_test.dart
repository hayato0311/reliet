import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/messages/c_f_checkpt_message.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/filter_type.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/hash256.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/var_hashes.dart';

void main() {
  group('create and serialize CFCheckptMessage instance', () {
    test('with valid args', () {
      const filterType = FilterType.basic;
      final stopHash = Hash256.create(const [0, 1, 1, 1, 1]);
      final filterHeaders = VarHashes([
        Hash256.create(const [1, 1, 1, 1, 1]),
        Hash256.create(const [1, 1, 1, 1, 2])
      ]);

      final cFHeadersMessage = CFCheckptMessage(
        filterType: filterType,
        stopHash: stopHash,
        filterHeaders: filterHeaders,
      );

      expect(
        cFHeadersMessage.serialize(),
        Uint8List.fromList([
          ...filterType.serialize(),
          ...stopHash.serialize(),
          ...filterHeaders.serialize(),
        ]),
      );
    });
  });
  group('deserialize bytes to BlockMessage instance', () {
    test('when valid', () {
      const filterType = FilterType.basic;
      final stopHash = Hash256.create(const [0, 1, 1, 1, 1]);
      final filterHeaders = VarHashes([
        Hash256.create(const [1, 1, 1, 1, 1]),
        Hash256.create(const [1, 1, 1, 1, 2])
      ]);

      final serializedCFHeadersMessage = CFCheckptMessage(
        filterType: filterType,
        stopHash: stopHash,
        filterHeaders: filterHeaders,
      ).serialize();

      final deserializedCFHeadersMessage = CFCheckptMessage.deserialize(
        Uint8List.fromList(serializedCFHeadersMessage),
      );

      expect(deserializedCFHeadersMessage, isA<CFCheckptMessage>());
      expect(
        deserializedCFHeadersMessage.filterType.value,
        filterType.value,
      );
      expect(
        deserializedCFHeadersMessage.stopHash.bytes,
        stopHash.bytes,
      );
      expect(
        deserializedCFHeadersMessage.filterHeaders.length.value,
        filterHeaders.length.value,
      );
      expect(
        deserializedCFHeadersMessage.filterHeaders.hashes[0].bytes,
        filterHeaders.hashes[0].bytes,
      );
      expect(
        deserializedCFHeadersMessage.filterHeaders.hashes[1].bytes,
        filterHeaders.hashes[1].bytes,
      );
    });
    test('with invalid bytes', () {
      expect(
        () => CFCheckptMessage.deserialize(Uint8List.fromList([0, 0, 0, 1])),
        throwsArgumentError,
      );
    });
  });
}
