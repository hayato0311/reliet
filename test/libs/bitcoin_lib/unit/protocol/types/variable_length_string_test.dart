import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_integer.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_string.dart';

void main() {
  group('serialize VarStr instance', () {
    test('with empty string', () {
      final varStr = VarStr('');

      expect(varStr.serialize(), [0x00]);
    });
    test('with string', () {
      final string = 'a' * 0xfc;
      final varStr = VarStr(string);

      expect(
        varStr.serialize(),
        Uint8List.fromList([0xfc, ...utf8.encode(string)]),
      );
    });
  });
  group('deserialize bytes to VarStr instance', () {
    test('with valid bytes', () {
      const varStrValue = 'valid';
      final serializedVarStrBytes = VarStr(varStrValue).serialize();
      print(serializedVarStrBytes);

      expect(VarStr.deserialize(serializedVarStrBytes).string, varStrValue);
    });
  });

  group('get length of bytes', () {
    test('with valid varStr instance', () {
      const varStrValue = 'valid';
      final varInt = VarInt(varStrValue.length);
      final varStr = VarStr(varStrValue);

      expect(varStr.bytesLength(), varInt.length + varInt.value);
    });
  });
}
