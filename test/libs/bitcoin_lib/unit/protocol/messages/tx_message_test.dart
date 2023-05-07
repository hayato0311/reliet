import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/messages/tx_message.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/bases/int64le.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/bases/uint32le.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/hash256.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/lock_time.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/script_pubkey.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/script_sig.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/tx_in.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/tx_out.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/tx_out_point.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/tx_version.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_integer.dart';

void main() {
  group('create and serialize TxMessage instance', () {
    group('when valid', () {
      test('with valid args', () {
        final version = TxVersion(1);
        final signature = List<int>.filled(72, 10);
        final txIns = [
          TxIn(
            TxOutPoint(
              Hash256.create(const [0, 1, 1, 1, 1]),
              Uint32le(10),
            ),
            ScriptSig.forP2PK(signature),
            Uint32le(1448484),
          ),
        ];

        final pubKey = List<int>.filled(33, 10);
        final txOuts = [
          TxOut(
            const Int64le(10000),
            ScriptPubKey.forP2PK(pubKey),
          ),
        ];

        final txMessage = TxMessage(
          version: version,
          txIns: txIns,
          txOuts: txOuts,
        );

        final serializedVersionMessage = <int>[
          ...version.serialize(),
          ...VarInt(txIns.length).serialize(),
          for (var txIn in txIns) ...txIn.serialize(),
          ...VarInt(txOuts.length).serialize(),
          for (var txOut in txOuts) ...txOut.serialize(),
          ...LockTime(0).serialize(),
        ];

        expect(
          txMessage.serialize(),
          Uint8List.fromList(serializedVersionMessage),
        );
      });
      test('with real tx data', () async {
        const path =
            'test/libs/bitcoin_lib/unit/protocol/messages/data/tx_f3c6.json';
        final jsonString = await File(path).readAsString();
        final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
        final bytes =
            (jsonData['bytes'] as List<dynamic>).map((e) => e as int).toList();

        final deserializedTxMessage =
            TxMessage.deserialize(Uint8List.fromList(bytes));

        expect(deserializedTxMessage.serialize(), jsonData['bytes']);
      });
    });
  });

  group('deserialize bytes to TxMessage instance', () {
    test('with valid bytes', () {
      final version = TxVersion(1);
      final signature = List<int>.filled(72, 10);
      final txIns = [
        TxIn(
          TxOutPoint(
            Hash256.create(const [0, 1, 1, 1, 1]),
            Uint32le(10),
          ),
          ScriptSig.forP2PK(signature),
          Uint32le(1448484),
        ),
      ];

      final pubKey = List<int>.filled(33, 10);
      final txOuts = [
        TxOut(
          const Int64le(10000),
          ScriptPubKey.forP2PK(pubKey),
        ),
      ];

      final txMessage = TxMessage(
        version: version,
        txIns: txIns,
        txOuts: txOuts,
      );

      final serializedTxMessage = txMessage.serialize();

      final deserializedTxMessage = TxMessage.deserialize(serializedTxMessage);

      expect(deserializedTxMessage, isA<TxMessage>());
      expect(deserializedTxMessage.version.value, txMessage.version.value);
      expect(deserializedTxMessage.txInCount.value, txMessage.txInCount.value);
      expect(
        deserializedTxMessage.txIns[0].previousOutput.hash.bytes,
        txMessage.txIns[0].previousOutput.hash.bytes,
      );
      expect(
        deserializedTxMessage.txIns[0].previousOutput.index.value,
        txMessage.txIns[0].previousOutput.index.value,
      );
      expect(
        deserializedTxMessage.txOutCount.value,
        txMessage.txOutCount.value,
      );
      expect(
        deserializedTxMessage.txOuts[0].value.value,
        txMessage.txOuts[0].value.value,
      );
      expect(
        deserializedTxMessage.txOuts[0].scriptPubkey.length.value,
        txMessage.txOuts[0].scriptPubkey.length.value,
      );
      expect(
        deserializedTxMessage.txOuts[0].scriptPubkey.commands,
        txMessage.txOuts[0].scriptPubkey.commands,
      );
      expect(
        deserializedTxMessage.txOuts[0].scriptPubkey.type,
        txMessage.txOuts[0].scriptPubkey.type,
      );
      expect(deserializedTxMessage.lockTime.value, txMessage.lockTime.value);
    });
    test('with invalid bytes', () {
      expect(
        () => TxMessage.deserialize(Uint8List.fromList([0, 0, 0, 1])),
        throwsArgumentError,
      );
    });
  });

  group('compute tx id', () {
    test('with real tx data', () async {
      const path =
          'test/libs/bitcoin_lib/unit/protocol/messages/data/tx_f3c6.json';
      final jsonString = await File(path).readAsString();
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final bytes =
          (jsonData['bytes'] as List<dynamic>).map((e) => e as int).toList();

      final deserializedTxMessage =
          TxMessage.deserialize(Uint8List.fromList(bytes));

      expect(deserializedTxMessage.hash(), jsonData['txId']);
    });
  });
}
