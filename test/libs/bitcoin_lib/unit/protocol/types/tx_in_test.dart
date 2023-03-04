import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/hash256.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/script_sig.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/sequence.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/tx_in.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/tx_out_point.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/tx_out_point_index.dart';

void main() {
  group('create and serialize TxIn instance', () {
    test('with valid params', () {
      final index = TxOutPointIndex(100);
      final hash = Hash256.create(const [1, 1, 1, 1]);
      final previousOutput = TxOutPoint(hash, index);
      final scriptSig = ScriptSig(const [1, 1, 1, 1]);
      final sequence = Sequence(100);
      final txIn = TxIn(previousOutput, scriptSig, sequence);

      final serializedTxIn = <int>[
        ...previousOutput.serialize(),
        ...scriptSig.serialize(),
        ...sequence.serialize(),
      ];

      expect(
        txIn.serialize(),
        Uint8List.fromList(serializedTxIn),
      );
    });
  });

  group('deserialize bytes to MessageHeader instance', () {
    test('with valid bytes', () {
      final index = TxOutPointIndex(100);
      final hash = Hash256.create(const [1, 1, 1, 1]);
      final previousOutput = TxOutPoint(hash, index);
      final scriptSig = ScriptSig(const [1, 1, 1, 1]);
      final sequence = Sequence(100);
      final txIn = TxIn(previousOutput, scriptSig, sequence);

      final serializedTxIn = txIn.serialize();

      expect(TxIn.deserialize(serializedTxIn), isA<TxIn>());
    });

    test('with invalid bytes', () {
      expect(
        () => TxIn.deserialize(
          Uint8List.fromList([0, 0, 0, 1]),
        ),
        throwsArgumentError,
      );
    });
  });
}
