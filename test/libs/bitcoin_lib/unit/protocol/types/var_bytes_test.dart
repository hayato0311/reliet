import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/var_bytes.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_integer.dart';

void main() {
  group('serialize VarBytes instance', () {
    test('with valid bytes', () {
      final bytes = List<int>.filled(10, 10) + List<int>.filled(10, 5);
      final varBytes = VarBytes(bytes);

      expect(
        varBytes.serialize(),
        Uint8List.fromList(bytes.reversed.toList()),
      );
    });
  });
  group('deserialize bytes to VarBytes instance', () {
    test('with valid bytes', () {
      final bytes = List<int>.filled(10, 10) + List<int>.filled(10, 5);
      final serializedVarStrBytes = VarBytes(bytes).serialize();

      expect(VarBytes.deserialize(serializedVarStrBytes).bytes, bytes);
    });
  });

  group('get length of bytes', () {
    test('with valid varBytes instance', () {
      final bytes = List<int>.filled(10, 10) + List<int>.filled(10, 5);
      final varInt = VarInt(bytes.length);
      final varBytes = VarBytes(bytes);

      expect(varBytes.bytesLength(), varInt.length + varInt.value);
    });
  });
}
