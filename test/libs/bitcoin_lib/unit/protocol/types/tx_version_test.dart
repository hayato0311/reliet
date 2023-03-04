import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/tx_version.dart';

void main() {
  group('create and serialize TxVersion instance', () {
    test('with valid params', () {
      const value = 1;
      final txVersion = TxVersion(value);

      expect(
        txVersion.serialize(),
        value.toUint32leBytes(),
      );
    });
    test('with invalid params', () {
      const value = 3;
      expect(
        () => TxVersion(value),
        throwsRangeError,
      );
    });
  });
  group('deserialize bytes to TxVersion instance', () {
    test('with valid bytes', () {
      const value = 1;
      final txVersion = TxVersion(value);

      final serializedTxVersion = txVersion.serialize();

      expect(TxVersion.deserialize(serializedTxVersion), isA<TxVersion>());
    });
    test('with invalid bytes', () {
      expect(
        () => TxVersion.deserialize(
          Uint8List.fromList([0, 0, 0, 1]),
        ),
        throwsArgumentError,
      );
    });
  });
}
