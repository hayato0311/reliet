import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/block_version.dart';

void main() {
  group('create and serialize BlockVersion instance', () {
    test('with valid params', () {
      const value = 1;
      const blockVersion = BlockVersion(value);

      expect(
        blockVersion.serialize(),
        value.toUint32leBytes(),
      );
    });
  });
  group('deserialize bytes to BlockVersion instance', () {
    test('with valid bytes', () {
      const value = 1;
      const blockVersion = BlockVersion(value);

      final serializedBlockVersion = blockVersion.serialize();

      expect(
        BlockVersion.deserialize(serializedBlockVersion),
        isA<BlockVersion>(),
      );
    });
    test('with invalid bytes', () {
      expect(
        () => BlockVersion.deserialize(
          Uint8List.fromList([0, 0, 0, 1, 5]),
        ),
        throwsArgumentError,
      );
    });
  });
}
