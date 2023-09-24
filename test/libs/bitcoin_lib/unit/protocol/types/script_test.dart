import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/op_code.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/script.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/script_type.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_integer.dart';

void main() {
  group('create Script instance, then serialize it', () {
    test('with valid args', () {
      final bytes = List<int>.filled(5, 10) + List<int>.filled(5, 5);
      final commands = [OpCode.opPushBytes10, bytes];
      final length = VarInt(10 + 1);
      final script = Script(length, commands, null);

      expect(script, isA<Script>());
      expect(script.length.value, length.value);
      expect(script.type, null);
      expect(script.bytesLength(), length.length + length.value);
      expect(script.commands, commands);
      expect(
        script.serialize(),
        Uint8List.fromList(
          [
            ...length.serialize(),
            OpCode.opPushBytes10.value,
            ...bytes,
          ],
        ),
      );
    });
  });

  group('deserialize from bytes to Script instance', () {
    test('with valid args', () {
      final bytes = List<int>.filled(5, 10) + List<int>.filled(5, 5);
      final commands = [OpCode.opPushBytes10, bytes];
      final length = VarInt(10 + 1);
      final script = Script(length, commands, null);

      final serializedScript = script.serialize();
      final deserializedScript = Script.deserialize(serializedScript);

      expect(deserializedScript, isA<Script>());
      expect(deserializedScript.length.value, length.value);
      expect(deserializedScript.type, null);
      expect(deserializedScript.commands, commands);
    });
  });

  group('get PubkeyHash', () {
    test('from a script of type P2PKH', () {
      final pubKeyHash = List<int>.filled(20, 10);
      final commands = [
        OpCode.opDup,
        OpCode.opHash160,
        OpCode.opPushBytes20,
        pubKeyHash,
        OpCode.opEqualVerify,
        OpCode.opCheckSig
      ];
      final length = VarInt(25);
      final script = Script(length, commands, ScriptType.p2pkh);

      expect(script.getPubkeyHash(), pubKeyHash);
    });
  });

  group('serialize commands', () {
    test('of type P2PKH', () {
      final pubKeyHash = List<int>.filled(20, 10);
      final commands = [
        OpCode.opDup,
        OpCode.opHash160,
        OpCode.opPushBytes20,
        pubKeyHash,
        OpCode.opEqualVerify,
        OpCode.opCheckSig
      ];

      expect(Script.serializeCommands(commands), [
        OpCode.opDup.value,
        OpCode.opHash160.value,
        OpCode.opPushBytes20.value,
        ...pubKeyHash,
        OpCode.opEqualVerify.value,
        OpCode.opCheckSig.value
      ]);
    });
  });
}
