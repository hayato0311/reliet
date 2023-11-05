import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/messages/get_blocks_message.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/hash256.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/protocol_version.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_integer.dart';

void main() {
  group('create and serialize VersionMessage instance', () {
    test('with valid args', () {
      const version = ProtocolVersion.defaultVersion;
      final locatorHashCount = VarInt(1);
      final locatorHashes = [
        Hash256.create(const [0, 1, 1, 1, 1])
      ];
      final stopHash = Hash256.create(const [0, 1, 1, 1, 1]);

      final getBlocksMessage = GetBlocksMessage(
        version: version,
        locatorHashes: locatorHashes,
        stopHash: stopHash,
      );

      final serializedGetBlocksMessage = <int>[
        ...version.serialize(),
        ...locatorHashCount.serialize(),
        for (var locatorHash in locatorHashes) ...locatorHash.serialize(),
        ...stopHash.serialize(),
      ];

      expect(
        getBlocksMessage.serialize(),
        Uint8List.fromList(serializedGetBlocksMessage),
      );
    });
  });
  group('deserialize bytes to GetBlocksMessage instance', () {
    test('with valid bytes', () {
      const version = ProtocolVersion.defaultVersion;
      final locatorHashCount = VarInt(1);
      final locatorHashes = [
        Hash256.create(const [0, 1, 1, 1, 1])
      ];
      final stopHash = Hash256.create(const [0, 1, 1, 1, 1]);
      final getBlocksMessage = GetBlocksMessage(
        version: version,
        locatorHashes: locatorHashes,
        stopHash: stopHash,
      );

      final serializedGetBlocksMessage = getBlocksMessage.serialize();

      final deserializedBlockMessage = GetBlocksMessage.deserialize(
        Uint8List.fromList(serializedGetBlocksMessage),
      );

      expect(deserializedBlockMessage, isA<GetBlocksMessage>());
      expect(
        deserializedBlockMessage.version.value,
        getBlocksMessage.version.value,
      );
      expect(
        deserializedBlockMessage.locatorHashCount.value,
        getBlocksMessage.locatorHashCount.value,
      );
      expect(
        deserializedBlockMessage.locatorHashes[0].bytes,
        getBlocksMessage.locatorHashes[0].bytes,
      );
      expect(
        deserializedBlockMessage.stopHash.bytes,
        getBlocksMessage.stopHash.bytes,
      );
    });
    test('with invalid bytes', () {
      expect(
        () => GetBlocksMessage.deserialize(Uint8List.fromList([0, 0, 0, 1])),
        throwsArgumentError,
      );
    });
  });
}
