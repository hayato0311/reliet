import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/tx_out_point_index.dart';

void main() {
  group('create and serialize TxOutPointIndex instance', () {
    test('with valid params', () {
      const value = 100;
      final txOutPointIndex = TxOutPointIndex(value);

      expect(
        txOutPointIndex.serialize(),
        value.toUint32leBytes(),
      );
    });
  });
  group('deserialize bytes to TxOutPointIndex instance', () {
    test('with valid bytes', () {
      const value = 100;
      final txOutPointIndex = TxOutPointIndex(value);

      final serializedTxOutPointIndex = txOutPointIndex.serialize();

      expect(
        TxOutPointIndex.deserialize(serializedTxOutPointIndex),
        isA<TxOutPointIndex>(),
      );
    });
    test('with invalid bytes', () {
      expect(
        () => TxOutPointIndex.deserialize(
          Uint8List.fromList([0, 0, 0, 1, 1]),
        ),
        throwsArgumentError,
      );
    });
  });
}
