import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/op_code.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/script_pubkey.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/script_type.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_integer.dart';

void main() {
  group('create ScriptPubKey instance, then serialize it', () {
    group('create through .forP2PK factory constructor', () {
      group('with compressed SEC pubKey', () {
        test('with valid pubKey', () {
          final pubKey = List<int>.filled(33, 10);
          final scriptPubKey = ScriptPubKey.forP2PK(pubKey);
          final scriptPubKeyLength = VarInt(33 + 2);

          expect(scriptPubKey, isA<ScriptPubKey>());
          expect(scriptPubKey.length.value, scriptPubKeyLength.value);
          expect(scriptPubKey.type, ScriptType.p2pk);
          expect(
            scriptPubKey.bytesLength(),
            scriptPubKeyLength.length + scriptPubKeyLength.value,
          );
          expect(
            scriptPubKey.commands,
            [OpCode.opPushBytes33, pubKey, OpCode.opCheckSig],
          );
          expect(
            scriptPubKey.serialize(),
            Uint8List.fromList([
              ...scriptPubKeyLength.serialize(),
              OpCode.opPushBytes33.value,
              ...pubKey.reversed,
              OpCode.opCheckSig.value
            ]),
          );
        });

        test('with invalid pubKey', () {
          final invalidPubKey = List<int>.filled(22, 10);
          expect(
            () => ScriptPubKey.forP2PK(invalidPubKey),
            throwsArgumentError,
          );
        });
      });

      group('with uncompressed SEC pubKey', () {
        test('with valid pubKey', () {
          final pubKey = List<int>.filled(65, 10);
          final scriptPubKey = ScriptPubKey.forP2PK(pubKey);
          final scriptPubKeyLength = VarInt(67);

          expect(scriptPubKey, isA<ScriptPubKey>());
          expect(scriptPubKey.length.value, scriptPubKeyLength.value);
          expect(scriptPubKey.type, ScriptType.p2pk);
          expect(
            scriptPubKey.bytesLength(),
            scriptPubKeyLength.length + scriptPubKeyLength.value,
          );
          expect(
            scriptPubKey.commands,
            [OpCode.opPushBytes65, pubKey, OpCode.opCheckSig],
          );
          expect(
            scriptPubKey.serialize(),
            Uint8List.fromList([
              ...scriptPubKeyLength.serialize(),
              OpCode.opPushBytes65.value,
              ...pubKey.reversed,
              OpCode.opCheckSig.value
            ]),
          );
        });

        test('with invalid pubKey', () {
          final invalidPubKey = List<int>.filled(22, 10);
          expect(
            () => ScriptPubKey.forP2PK(invalidPubKey),
            throwsArgumentError,
          );
        });
      });
    });
    group('create through .forP2PKH factory constructor', () {
      test('with valid pubKey', () {
        final pubKeyHash = List<int>.filled(20, 10);
        final scriptPubKey = ScriptPubKey.forP2PKH(pubKeyHash);
        final scriptPubKeyLength = VarInt(25);

        expect(scriptPubKey, isA<ScriptPubKey>());
        expect(scriptPubKey.length.value, scriptPubKeyLength.value);
        expect(scriptPubKey.type, ScriptType.p2pkh);
        expect(
          scriptPubKey.bytesLength(),
          scriptPubKeyLength.length + scriptPubKeyLength.value,
        );
        expect(
          scriptPubKey.commands,
          [
            OpCode.opDup,
            OpCode.opHash160,
            OpCode.opPushBytes20,
            pubKeyHash,
            OpCode.opEqualVerify,
            OpCode.opCheckSig
          ],
        );
        expect(
          scriptPubKey.serialize(),
          Uint8List.fromList([
            ...scriptPubKeyLength.serialize(),
            OpCode.opDup.value,
            OpCode.opHash160.value,
            OpCode.opPushBytes20.value,
            ...pubKeyHash.reversed,
            OpCode.opEqualVerify.value,
            OpCode.opCheckSig.value
          ]),
        );
      });

      test('with invalid pubKey', () {
        final invalidPubKeyHash = List<int>.filled(21, 10);
        expect(
          () => ScriptPubKey.forP2PK(invalidPubKeyHash),
          throwsArgumentError,
        );
      });
    });
  });

  group('deserialize from bytes to ScriptPubKey instance', () {
    group('with p2pk bytes', () {
      group('with compressed SEC pubKey', () {
        test('with valid bytes', () {
          final pubKey = List<int>.filled(33, 10);
          final scriptPubKey = ScriptPubKey.forP2PK(pubKey);
          final serializedScriptPubKey = scriptPubKey.serialize();
          final deserializedScriptPubKey =
              ScriptPubKey.deserialize(serializedScriptPubKey);

          expect(deserializedScriptPubKey, isA<ScriptPubKey>());
          expect(
            deserializedScriptPubKey.length.value,
            scriptPubKey.length.value,
          );
          expect(deserializedScriptPubKey.type, scriptPubKey.type);
          expect(deserializedScriptPubKey.commands, scriptPubKey.commands);
        });
      });

      group('with uncompressed SEC pubKey', () {
        test('with valid bytes', () {
          final pubKey = List<int>.filled(65, 10);
          final scriptPubKey = ScriptPubKey.forP2PK(pubKey);
          final serializedScriptPubKey = scriptPubKey.serialize();
          final deserializedScriptPubKey =
              ScriptPubKey.deserialize(serializedScriptPubKey);

          expect(deserializedScriptPubKey, isA<ScriptPubKey>());
          expect(
            deserializedScriptPubKey.length.value,
            scriptPubKey.length.value,
          );
          expect(deserializedScriptPubKey.type, scriptPubKey.type);
          expect(deserializedScriptPubKey.commands, scriptPubKey.commands);
        });
      });
    });
    group('with p2pkh bytes', () {
      test('with valid bytes', () {
        final pubKeyHash = List<int>.filled(20, 10);
        final scriptPubKey = ScriptPubKey.forP2PKH(pubKeyHash);
        final serializedScriptPubKey = scriptPubKey.serialize();
        final deserializedScriptPubKey =
            ScriptPubKey.deserialize(serializedScriptPubKey);

        expect(deserializedScriptPubKey, isA<ScriptPubKey>());
        expect(
          deserializedScriptPubKey.length.value,
          scriptPubKey.length.value,
        );
        expect(deserializedScriptPubKey.type, scriptPubKey.type);
        expect(deserializedScriptPubKey.commands, scriptPubKey.commands);
      });
    });
  });
}
