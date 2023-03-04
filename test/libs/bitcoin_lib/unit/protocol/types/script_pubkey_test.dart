import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/script_pubkey.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_integer.dart';

void main() {
  group('serialize ScriptPubKey instance', () {
    test('with valid bytes', () {
      const bytes = [0x00, 0x01];
      final scriptPubKeyBytes = ScriptPubKey(bytes);

      expect(
        scriptPubKeyBytes.serialize(),
        Uint8List.fromList([bytes.length, ...bytes]),
      );
    });
  });
  group('deserialize bytes to ScriptPubKey instance', () {
    test('with valid bytes', () {
      const bytes = [0x00, 0x01];
      final serializedScriptPubKeyBytes = ScriptPubKey(bytes).serialize();

      expect(
        ScriptPubKey.deserialize(serializedScriptPubKeyBytes).bytes,
        bytes,
      );
    });
  });

  group('get length of bytes', () {
    test('with valid varStr instance', () {
      const varStrValue = [0x00, 0x01];
      final varInt = VarInt(varStrValue.length);
      final scriptPubKey = ScriptPubKey(varStrValue);

      expect(scriptPubKey.bytesLength(), varInt.length + varInt.value);
    });
  });
}
