import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../types/block_header.dart';
import '../types/variable_length_integer.dart';
import 'tx_message.dart';

@immutable
class BlockMessage {
  const BlockMessage._internal(
    this.header,
    this.txCount,
    this.txs,
  );

  factory BlockMessage.deserialize(Uint8List bytes) {
    var startIndex = 0;
    final header = BlockHeader.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + BlockHeader.bytesLength(),
      ),
    );
    startIndex += BlockHeader.bytesLength();

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
      header,
      txCount,
      txs,
    );
  }

  final BlockHeader header;
  final VarInt txCount;
  final List<TxMessage> txs;

  int bytesLength() {
    var txsByteLength = 0;
    for (final tx in txs) {
      txsByteLength += tx.bytesLength();
    }
    return BlockHeader.bytesLength() + txCount.bytesLength() + txsByteLength;
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'txCount': txCount.toJson(),
        'txs': [for (var tx in txs) tx.toJson()],
      };
}
