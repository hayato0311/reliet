import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/messages/block_message.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/messages/tx_message.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/bases/int64le.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/bases/uint32le.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/block_version.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/hash256.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/script_pubkey.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/script_sig.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/tx_in.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/tx_out.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/tx_out_point.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/tx_version.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_integer.dart';

void main() {
  group('deserialize bytes to BlockMessage instance', () {
    test('with valid bytes', () {
      const version = BlockVersion(1);
      final previousBlockHash = Hash256.create(const [0, 1, 1, 1, 1]);
      final merkleRoot = Hash256.create(const [0, 1, 1, 1, 1]);
      final timestamp = Uint32le(10000);
      final bits = Uint32le(10000);
      final nonce = Uint32le(10000);
      final txCount = VarInt(1);
      final txs = [
        TxMessage(
          version: TxVersion(1),
          txIns: [
            TxIn(
              TxOutPoint(
                Hash256.create(const [0, 1, 1, 1, 1]),
                Uint32le(10),
              ),
              ScriptSig.forP2PK(List<int>.filled(72, 10)),
              Uint32le(1448484),
            ),
          ],
          txOuts: [
            TxOut(
              const Int64le(10000),
              ScriptPubKey.forP2PK(List<int>.filled(33, 10)),
            ),
          ],
        ),
      ];

      final serializedBlockMessage = <int>[
        ...version.serialize(),
        ...previousBlockHash.serialize(),
        ...merkleRoot.serialize(),
        ...timestamp.serialize(),
        ...bits.serialize(),
        ...nonce.serialize(),
        ...txCount.serialize(),
        for (var tx in txs) ...tx.serialize(),
      ];

      final deserializedBlockMessage =
          BlockMessage.deserialize(Uint8List.fromList(serializedBlockMessage));

      expect(deserializedBlockMessage, isA<BlockMessage>());
      expect(
        deserializedBlockMessage.header.version.value,
        version.value,
      );
      expect(
        deserializedBlockMessage.header.previousBlockHash.bytes,
        previousBlockHash.bytes,
      );
      expect(
        deserializedBlockMessage.header.merkleRoot.bytes,
        merkleRoot.bytes,
      );
      expect(
        deserializedBlockMessage.header.timestamp.value,
        timestamp.value,
      );
      expect(
        deserializedBlockMessage.header.bits.value,
        bits.value,
      );
      expect(
        deserializedBlockMessage.header.nonce.value,
        nonce.value,
      );
      expect(
        deserializedBlockMessage.txCount.value,
        txCount.value,
      );
      expect(
        deserializedBlockMessage.txs[0],
        isA<TxMessage>(),
      );
    });
    test('with invalid bytes', () {
      expect(
        () => BlockMessage.deserialize(Uint8List.fromList([0, 0, 0, 1])),
        throwsArgumentError,
      );
    });
  });

  test('compute block hash', () async {
    const path =
        'test/libs/bitcoin_lib/unit/protocol/messages/data/block_788080.json';
    final jsonString = await File(path).readAsString();
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    final bytes =
        (jsonData['bytes'] as List<dynamic>).map((e) => e as int).toList();

    final deserializedBlockMessage =
        BlockMessage.deserialize(Uint8List.fromList(bytes));

    expect(
      deserializedBlockMessage.header.blockHash(),
      jsonData['blockHash'],
    );
  });
}
