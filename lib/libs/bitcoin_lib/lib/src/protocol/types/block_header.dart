import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../extensions/uint8_list_extensions.dart';
import '../types/bases/uint32le.dart';
import '../types/block_version.dart';
import '../types/hash256.dart';

@immutable
class BlockHeader {
  const BlockHeader._internal(
    this.version,
    this.previousBlockHash,
    this.merkleRoot,
    this.timestamp,
    this.bits,
    this.nonce,
  );

  factory BlockHeader.deserialize(Uint8List bytes) {
    var startIndex = 0;
    final version = BlockVersion.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + BlockVersion.bytesLength(),
      ),
    );
    startIndex += BlockVersion.bytesLength();

    final previousBlockHash = Hash256.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Hash256.bytesLength(),
      ),
    );
    startIndex += Hash256.bytesLength();

    final merkleRoot = Hash256.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Hash256.bytesLength(),
      ),
    );
    startIndex += Hash256.bytesLength();

    final timestamp = Uint32le.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Uint32le.bytesLength(),
      ),
    );
    startIndex += Uint32le.bytesLength();

    final bits = Uint32le.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Uint32le.bytesLength(),
      ),
    );
    startIndex += Uint32le.bytesLength();

    final nonce = Uint32le.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Uint32le.bytesLength(),
      ),
    );
    startIndex += Uint32le.bytesLength();

    return BlockHeader._internal(
      version,
      previousBlockHash,
      merkleRoot,
      timestamp,
      bits,
      nonce,
    );
  }

  final BlockVersion version;
  final Hash256 previousBlockHash;
  final Hash256 merkleRoot;
  final Uint32le timestamp;
  final Uint32le bits;
  final Uint32le nonce;

  static int bytesLength() {
    return BlockVersion.bytesLength() +
        Hash256.bytesLength() +
        Hash256.bytesLength() +
        Uint32le.bytesLength() +
        Uint32le.bytesLength() +
        Uint32le.bytesLength();
  }

  Map<String, dynamic> toJson() => {
        'blockHash': blockHash(),
        'version': version.toJson(),
        'previousBlockHash': previousBlockHash.toJson(),
        'merkleRoot': merkleRoot.toJson(),
        'timestamp': timestamp.toJson(),
        'bits': bits.toJson(),
        'nonce': nonce.toJson(),
      };

  String blockHash() {
    final byteList = <int>[
      ...version.serialize(),
      ...previousBlockHash.serialize(),
      ...merkleRoot.serialize(),
      ...timestamp.serialize(),
      ...bits.serialize(),
      ...nonce.serialize(),
    ];
    final hash256 = Hash256.create(Uint8List.fromList(byteList));
    return Uint8List.fromList(hash256.bytes.reversed.toList()).toHex();
  }
}
