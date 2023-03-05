import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/bases/uint32le.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/hash256.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/tx_out_point.dart';

void main() {
  group('create and serialize TxOutPoint instance', () {
    test('with valid params', () {
      final hash = Hash256.create(const [1, 1, 1, 1]);
      final index = Uint32le(100);
      final txOutPoint = TxOutPoint(hash, index);

      final serializedInventory = <int>[
        ...hash.serialize(),
        ...index.serialize(),
      ];

      expect(
        txOutPoint.serialize(),
        Uint8List.fromList(serializedInventory),
      );
    });
  });
  group('deserialize bytes to TxOutPoint instance', () {
    test('with valid bytes', () {
      final hash = Hash256.create(const [1, 1, 1, 1]);
      final index = Uint32le(100);
      final txOutPoint = TxOutPoint(hash, index);

      final serializedTxOutPoint = txOutPoint.serialize();

      expect(TxOutPoint.deserialize(serializedTxOutPoint), isA<TxOutPoint>());
    });
    test('with invalid bytes', () {
      expect(
        () => TxOutPoint.deserialize(
          Uint8List.fromList([0, 0, 0, 1]),
        ),
        throwsArgumentError,
      );
    });
  });
}
