import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/hash256.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/var_hashes.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_integer.dart';

void main() {
  group('create and serialize VarHashes instance', () {
    test('when valid', () {
      final hashes = [
        Hash256.create(const [1, 1, 1, 1, 1]),
        Hash256.create(const [1, 1, 1, 1, 2])
      ];
      final varHashes = VarHashes(hashes);

      expect(
        varHashes.serialize(),
        Uint8List.fromList([
          ...VarInt(hashes.length).serialize(),
          for (final hash in hashes) ...hash.serialize()
        ]),
      );
    });

    group('deserialize bytes to VarHashes instance', () {
      test('when valid', () {
        final hashes = [
          Hash256.create(const [1, 1, 1, 1, 1]),
          Hash256.create(const [1, 1, 1, 1, 2])
        ];
        final serializedVarHashBytes = VarHashes(hashes).serialize();

        expect(
          VarHashes.deserialize(serializedVarHashBytes).hashes[0].bytes,
          hashes[0].bytes,
        );
        expect(
          VarHashes.deserialize(serializedVarHashBytes).hashes[1].bytes,
          hashes[1].bytes,
        );
      });
    });

    group('get length of bytes', () {
      test('when valid', () {
        final hashes = [
          Hash256.create(const [1, 1, 1, 1, 1]),
          Hash256.create(const [1, 1, 1, 1, 2])
        ];
        final varInt = VarInt(hashes.length);
        final varHashes = VarHashes(hashes);

        expect(varHashes.bytesLength(), varInt.length + varInt.value);
      });
    });
  });
}
