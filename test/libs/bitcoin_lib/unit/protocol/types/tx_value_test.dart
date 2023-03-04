import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/tx_value.dart';

void main() {
  group('create and serialize TxValue instance', () {
    test('with valid params', () {
      const value = 100;
      final txValue = TxValue(value);

      expect(
        txValue.serialize(),
        value.toInt64leBytes(),
      );
    });
  });
  group('deserialize bytes to TxValue instance', () {
    test('with valid bytes', () {
      const value = 100;
      final txValue = TxValue(value);

      final serializedTxValue = txValue.serialize();

      expect(TxValue.deserialize(serializedTxValue), isA<TxValue>());
    });
    test('with invalid bytes', () {
      expect(
        () => TxValue.deserialize(
          Uint8List.fromList([0, 0, 0, 1]),
        ),
        throwsArgumentError,
      );
    });
  });
}
