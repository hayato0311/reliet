import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/script_sig.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_integer.dart';

void main() {
  group('serialize ScriptSig instance', () {
    test('with valid bytes', () {
      const bytes = [0x00, 0x01];
      final scriptPubKeyBytes = ScriptSig(bytes);

      expect(
        scriptPubKeyBytes.serialize(),
        Uint8List.fromList([bytes.length, ...bytes]),
      );
    });
  });
  group('deserialize bytes to ScriptSig instance', () {
    test('with valid bytes', () {
      const bytes = [0x00, 0x01];
      final serializedScriptSigBytes = ScriptSig(bytes).serialize();

      expect(
        ScriptSig.deserialize(serializedScriptSigBytes).bytes,
        bytes,
      );
    });
  });

  group('get length of bytes', () {
    test('with valid varStr instance', () {
      const varStrValue = [0x00, 0x01];
      final varInt = VarInt(varStrValue.length);
      final scriptSig = ScriptSig(varStrValue);

      expect(scriptSig.bytesLength(), varInt.length + varInt.value);
    });
  });
}
