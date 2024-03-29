import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/bases/int64le.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/script_pubkey.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/tx_out.dart';

void main() {
  group('create and serialize TxOut instance', () {
    test('with valid params', () {
      const txValue = Int64le(100);
      final pubKey = List<int>.filled(33, 10);
      final scriptPubKey = ScriptPubKey.forP2PK(pubKey);
      final txOut = TxOut(txValue, scriptPubKey);

      final serializedTxOut = <int>[
        ...txValue.serialize(),
        ...scriptPubKey.serialize(),
      ];

      expect(
        txOut.serialize(),
        Uint8List.fromList(serializedTxOut),
      );
    });
  });
  group('deserialize bytes to TxOut instance', () {
    test('with valid bytes', () {
      const txValue = Int64le(100);
      final pubKey = List<int>.filled(33, 10);
      final scriptPubKey = ScriptPubKey.forP2PK(pubKey);
      final txOut = TxOut(txValue, scriptPubKey);

      final serializedTxOut = txOut.serialize();

      expect(TxOut.deserialize(serializedTxOut), isA<TxOut>());
    });
    test('with invalid bytes', () {
      expect(
        () => TxOut.deserialize(
          Uint8List.fromList([0, 0, 0, 1]),
        ),
        throwsArgumentError,
      );
    });
  });
}
