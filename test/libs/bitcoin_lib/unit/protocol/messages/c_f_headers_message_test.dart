import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/messages/c_f_headers_message.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/filter_type.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/hash256.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/var_hashes.dart';

void main() {
  group('create and serialize CFHeadersMessage instance', () {
    test('with valid args', () {
      const filterType = FilterType.basic;
      final stopHash = Hash256.create(const [0, 1, 1, 1, 1]);
      final prevHeader = Hash256.create(const [0, 1, 1, 1, 1]);
      final filterHashes = VarHashes([
        Hash256.create(const [1, 1, 1, 1, 1]),
        Hash256.create(const [1, 1, 1, 1, 2])
      ]);

      final cFHeadersMessage = CFHeadersMessage(
        filterType: filterType,
        stopHash: stopHash,
        prevHeader: prevHeader,
        filterHashes: filterHashes,
      );

      expect(
        cFHeadersMessage.serialize(),
        Uint8List.fromList([
          ...filterType.serialize(),
          ...stopHash.serialize(),
          ...prevHeader.serialize(),
          ...filterHashes.serialize(),
        ]),
      );
    });
  });
  group('deserialize bytes to BlockMessage instance', () {
    test('when valid', () {
      const filterType = FilterType.basic;
      final stopHash = Hash256.create(const [0, 1, 1, 1, 1]);
      final prevHeader = Hash256.create(const [0, 1, 1, 1, 1]);
      final filterHashes = VarHashes([
        Hash256.create(const [1, 1, 1, 1, 1]),
        Hash256.create(const [1, 1, 1, 1, 2])
      ]);

      final serializedCFHeadersMessage = CFHeadersMessage(
        filterType: filterType,
        stopHash: stopHash,
        prevHeader: prevHeader,
        filterHashes: filterHashes,
      ).serialize();

      final deserializedCFHeadersMessage = CFHeadersMessage.deserialize(
        Uint8List.fromList(serializedCFHeadersMessage),
      );

      expect(deserializedCFHeadersMessage, isA<CFHeadersMessage>());
      expect(
        deserializedCFHeadersMessage.filterType.value,
        filterType.value,
      );
      expect(
        deserializedCFHeadersMessage.stopHash.bytes,
        stopHash.bytes,
      );
      expect(
        deserializedCFHeadersMessage.filterHashes.length.value,
        filterHashes.length.value,
      );
      expect(
        deserializedCFHeadersMessage.filterHashes.hashes[0].bytes,
        filterHashes.hashes[0].bytes,
      );
      expect(
        deserializedCFHeadersMessage.filterHashes.hashes[1].bytes,
        filterHashes.hashes[1].bytes,
      );
    });
    test('with invalid bytes', () {
      expect(
        () => CFHeadersMessage.deserialize(Uint8List.fromList([0, 0, 0, 1])),
        throwsArgumentError,
      );
    });
  });
}
