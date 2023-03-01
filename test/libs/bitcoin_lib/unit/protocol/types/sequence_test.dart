import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/sequence.dart';

void main() {
  group('create and serialize Sequence instance', () {
    test('with valid params', () {
      const value = 100;
      final txVersion = Sequence(value);

      expect(
        txVersion.serialize(),
        value.toUint32leBytes(),
      );
    });
  });
  group('deserialize bytes to Sequence instance', () {
    test('with valid bytes', () {
      const value = 100;
      final txVersion = Sequence(value);

      final serializedTxVersion = txVersion.serialize();

      expect(Sequence.deserialize(serializedTxVersion), isA<Sequence>());
    });
    test('with invalid bytes', () {
      expect(
        () => Sequence.deserialize(
          Uint8List.fromList([0, 0, 0, 0, 1]),
        ),
        throwsArgumentError,
      );
    });
  });
}
