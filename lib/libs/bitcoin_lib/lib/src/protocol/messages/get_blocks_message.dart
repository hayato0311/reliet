import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../types/hash256.dart';
import '../types/protocol_version.dart';
import '../types/variable_length_integer.dart';

@immutable
class GetBlocksMessage {
  factory GetBlocksMessage({
    required ProtocolVersion version,
    required List<Hash256> locatorHashes,
    required Hash256 stopHash,
  }) {
    return GetBlocksMessage._internal(
      version,
      VarInt(locatorHashes.length),
      locatorHashes,
      stopHash,
    );
  }

  const GetBlocksMessage._internal(
    this.version,
    this.locatorHashCount,
    this.locatorHashes,
    this.stopHash,
  );

  factory GetBlocksMessage.deserialize(Uint8List bytes) {
    var startIndex = 0;
    final version = ProtocolVersion.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + ProtocolVersion.bytesLength(),
      ),
    );
    startIndex += ProtocolVersion.bytesLength();

    final locatorHashCount = VarInt.deserialize(
      bytes.sublist(startIndex),
    );
    startIndex += locatorHashCount.bytesLength();

    final locatorHashes = <Hash256>[];
    for (var i = 0; i < locatorHashCount.value; i++) {
      final locatorHash = Hash256.deserialize(
        bytes.sublist(
          startIndex,
          startIndex + Hash256.bytesLength(),
        ),
      );
      locatorHashes.add(locatorHash);
    }
    startIndex += Hash256.bytesLength() * locatorHashCount.value;

    final stopHash = Hash256.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Hash256.bytesLength(),
      ),
    );
    startIndex += Hash256.bytesLength();

    return GetBlocksMessage._internal(
      version,
      locatorHashCount,
      locatorHashes,
      stopHash,
    );
  }

  final ProtocolVersion version;
  final VarInt locatorHashCount;
  final List<Hash256> locatorHashes;
  final Hash256 stopHash;

  int bytesLength() {
    return ProtocolVersion.bytesLength() +
        locatorHashCount.bytesLength() +
        locatorHashCount.value * Hash256.bytesLength() +
        Hash256.bytesLength();
  }

  Map<String, dynamic> toJson() => {
        'version': version.toJson(),
        'locatorHashCount': locatorHashCount.toJson(),
        'locatorHashes': [
          for (var locatorHash in locatorHashes) locatorHash.toJson()
        ],
        'stopHash': stopHash.toJson(),
      };

  Uint8List serialize() {
    final byteList = <int>[
      ...version.serialize(),
      ...locatorHashCount.serialize(),
      for (var locatorHash in locatorHashes) ...locatorHash.serialize(),
      ...stopHash.serialize(),
    ];

    return Uint8List.fromList(byteList);
  }
}
