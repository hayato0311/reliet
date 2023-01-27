import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_string.dart';

void main() {
  group('serialize VarStr instance', () {
    test('with empty string', () {
      final VarStr varStr = VarStr("");

      expect(varStr.serialize(), [0x00]);
    });
    test('with string', () {
      final String string = "a" * 0xfc;
      final VarStr varStr = VarStr(string);

      List<int> serializedVarStr = [0xfc] + utf8.encode(string).toList();

      expect(varStr.serialize(), Uint8List.fromList(serializedVarStr));
    });
  });
}
