import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/bases/int64le.dart';

void main() {
  group('create and serialize Int64le instance', () {
    test('with valid params', () {
      const value = 100;
      const txValue = Int64le(value);

      expect(
        txValue.serialize(),
        value.toInt64leBytes(),
      );
    });
  });
  group('deserialize bytes to Int64le instance', () {
    test('with valid bytes', () {
      const value = 100;
      const txValue = Int64le(value);

      final serializedInt64le = txValue.serialize();

      expect(Int64le.deserialize(serializedInt64le), isA<Int64le>());
    });
    test('with invalid bytes', () {
      expect(
        () => Int64le.deserialize(
          Uint8List.fromList([0, 0, 0, 1]),
        ),
        throwsArgumentError,
      );
    });
  });
}
