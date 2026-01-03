import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/var_bytes.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_integer.dart';

void main() {
  group('create and serialize VarBytes instance', () {
    test('with valid bytes', () {
      final bytes = Uint8List.fromList(
        List<int>.filled(10, 10) + List<int>.filled(10, 5),
      );
      final varBytes = VarBytes(bytes);

      expect(
        varBytes.serialize(),
        Uint8List.fromList([
          ...VarInt(bytes.length).serialize(),
          ...bytes.reversed,
        ]),
      );
    });
  });
  group('deserialize bytes to VarBytes instance', () {
    test('with valid bytes', () {
      final bytes = Uint8List.fromList(
        List<int>.filled(10, 10) + List<int>.filled(10, 5),
      );
      final serializedVarBytes = VarBytes(bytes).serialize();

      expect(VarBytes.deserialize(serializedVarBytes).bytes, bytes);
    });
  });

  group('get length of bytes', () {
    test('with valid varBytes instance', () {
      final bytes = Uint8List.fromList(
        List<int>.filled(10, 10) + List<int>.filled(10, 5),
      );
      final varInt = VarInt(bytes.length);
      final varBytes = VarBytes(bytes);

      expect(varBytes.bytesLength(), varInt.length + varInt.value);
    });
  });
}
