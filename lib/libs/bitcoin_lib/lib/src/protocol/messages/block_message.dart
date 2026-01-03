import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../extensions/uint8_list_extensions.dart';
import '../types/bases/uint32le.dart';
import '../types/block_version.dart';
import '../types/hash256.dart';
import '../types/variable_length_integer.dart';
import 'tx_message.dart';

@immutable
class BlockMessage {
  const BlockMessage._internal(
    this.version,
    this.previousBlockHash,
    this.merkleRoot,
    this.timestamp,
    this.bits,
    this.nonce,
    this.txCount,
    this.txs,
  );

  factory BlockMessage.deserialize(Uint8List bytes) {
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

    final txCount = VarInt.deserialize(
      bytes.sublist(startIndex),
    );
    startIndex += txCount.bytesLength();

    final txs = <TxMessage>[];
    for (var i = 0; i < txCount.value; i++) {
      final tx = TxMessage.deserialize(
        bytes.sublist(startIndex),
      );
      startIndex += tx.bytesLength();
      txs.add(tx);
    }

    return BlockMessage._internal(
      version,
      previousBlockHash,
      merkleRoot,
      timestamp,
      bits,
      nonce,
      txCount,
      txs,
    );
  }

  final BlockVersion version;
  final Hash256 previousBlockHash;
  final Hash256 merkleRoot;
  final Uint32le timestamp;
  final Uint32le bits;
  final Uint32le nonce;
  final VarInt txCount;
  final List<TxMessage> txs;

  int bytesLength() {
    var txsByteLength = 0;
    for (final tx in txs) {
      txsByteLength += tx.bytesLength();
    }
    return BlockVersion.bytesLength() +
        Hash256.bytesLength() +
        Hash256.bytesLength() +
        Uint32le.bytesLength() +
        Uint32le.bytesLength() +
        Uint32le.bytesLength() +
        txCount.bytesLength() +
        txsByteLength;
  }

  Map<String, dynamic> toJson() => {
        'blockHash': blockHash(),
        'version': version.toJson(),
        'previousBlockHash': previousBlockHash.toJson(),
        'merkleRoot': merkleRoot.toJson(),
        'timestamp': timestamp.toJson(),
        'bits': bits.toJson(),
        'nonce': nonce.toJson(),
        'txCount': txCount.toJson(),
        'txs': [for (var tx in txs) tx.toJson()],
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
    return Uint8List.fromList(hash256.bytes.reversed.toList())
        .toHex(prefix: false);
  }
}
