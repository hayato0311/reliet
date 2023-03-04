import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/script_pubkey.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/tx_out.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/tx_value.dart';

void main() {
  group('create and serialize TxOut instance', () {
    test('with valid params', () {
      final value = TxValue(100);
      final scriptPubKey = ScriptPubKey(const [1, 1, 1, 1]);
      final txOut = TxOut(value, scriptPubKey);

      final serializedTxOut = <int>[
        ...value.serialize(),
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
      final value = TxValue(100);
      final scriptPubKey = ScriptPubKey(const [1, 1, 1, 1]);
      final txOut = TxOut(value, scriptPubKey);

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
