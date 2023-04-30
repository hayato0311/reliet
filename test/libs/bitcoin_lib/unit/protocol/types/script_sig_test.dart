import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/op_code.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/script_sig.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/script_type.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_integer.dart';

void main() {
  group('create ScriptPubKey instance, then serialize it', () {
    group('create through .forP2PK factory constructor', () {
      test('with valid pubKey', () {
        final signature = List<int>.filled(74, 10);
        final scriptSig = ScriptSig.forP2PK(signature);
        final scriptSigLength = VarInt(signature.length + 1);

        expect(scriptSig, isA<ScriptSig>());
        expect(scriptSig.length.value, scriptSigLength.value);
        expect(scriptSig.type, ScriptType.p2pk);
        expect(
          scriptSig.bytesLength(),
          scriptSigLength.length + scriptSigLength.value,
        );
        expect(
          scriptSig.commands,
          [OpCode.opPushBytes74, signature],
        );
        expect(
          scriptSig.serialize(),
          Uint8List.fromList([
            ...scriptSigLength.serialize(),
            ...OpCode.opPushBytes74.serialize(),
            ...signature.reversed,
          ]),
        );
      });

      test('with invalid pubKey', () {
        final invalidSignature = List<int>.filled(100, 10);
        expect(
          () => ScriptSig.forP2PK(invalidSignature),
          throwsArgumentError,
        );
      });
    });
    group('create through .forP2PKH factory constructor', () {
      group('with compressed SEC pubKey', () {
        group('when valid', () {
          test('with valid signature and pubKey', () {
            final signature = List<int>.filled(74, 10);
            final pubKey = List<int>.filled(33, 10);
            final scriptSig = ScriptSig.forP2PKH(signature, pubKey);
            final scriptSigLength = VarInt(signature.length + 33 + 2);

            expect(scriptSig, isA<ScriptSig>());
            expect(scriptSig.length.value, scriptSigLength.value);
            expect(scriptSig.type, ScriptType.p2pkh);
            expect(
              scriptSig.bytesLength(),
              scriptSigLength.length + scriptSigLength.value,
            );
            expect(
              scriptSig.commands,
              [
                OpCode.opPushBytes74,
                signature,
                OpCode.opPushBytes33,
                pubKey,
              ],
            );
            expect(
              scriptSig.serialize(),
              Uint8List.fromList([
                ...scriptSigLength.serialize(),
                ...OpCode.opPushBytes74.serialize(),
                ...signature.reversed,
                ...OpCode.opPushBytes33.serialize(),
                ...pubKey.reversed,
              ]),
            );
          });
        });

        group('when invalid', () {
          test('with invalid signature', () {
            final invalidSignature = List<int>.filled(100, 10);
            final pubKey = List<int>.filled(33, 10);
            expect(
              () => ScriptSig.forP2PKH(invalidSignature, pubKey),
              throwsArgumentError,
            );
          });
        });
      });

      group('with uncompressed SEC pubKey', () {
        group('when valid', () {
          test('with valid signature and pubKey', () {
            final signature = List<int>.filled(74, 10);
            final pubKey = List<int>.filled(65, 10);
            final scriptSig = ScriptSig.forP2PKH(signature, pubKey);
            final scriptSigLength = VarInt(signature.length + 65 + 2);

            expect(scriptSig, isA<ScriptSig>());
            expect(scriptSig.length.value, scriptSigLength.value);
            expect(scriptSig.type, ScriptType.p2pkh);
            expect(
              scriptSig.bytesLength(),
              scriptSigLength.length + scriptSigLength.value,
            );
            expect(
              scriptSig.commands,
              [
                OpCode.opPushBytes74,
                signature,
                OpCode.opPushBytes65,
                pubKey,
              ],
            );
            expect(
              scriptSig.serialize(),
              Uint8List.fromList([
                ...scriptSigLength.serialize(),
                ...OpCode.opPushBytes74.serialize(),
                ...signature.reversed,
                ...OpCode.opPushBytes65.serialize(),
                ...pubKey.reversed,
              ]),
            );
          });
        });

        group('when invalid', () {
          test('with invalid signature', () {
            final invalidSignature = List<int>.filled(100, 10);
            final pubKey = List<int>.filled(65, 10);
            expect(
              () => ScriptSig.forP2PKH(invalidSignature, pubKey),
              throwsArgumentError,
            );
          });
        });
      });
      test('with a pubKey that does not comply with the SEC format.', () {
        final signature = List<int>.filled(74, 10);
        final invalidPubKey = List<int>.filled(50, 10);
        expect(
          () => ScriptSig.forP2PKH(signature, invalidPubKey),
          throwsArgumentError,
        );
      });
    });
  });

  group('deserialize from bytes to ScriptSig instance', () {
    group('with p2pk bytes', () {
      group('with compressed SEC pubKey', () {
        test('with valid bytes', () {
          final signature = List<int>.filled(74, 10);
          final scriptSig = ScriptSig.forP2PK(signature);
          final serializedScriptSig = scriptSig.serialize();
          final deserializedScriptSig =
              ScriptSig.deserialize(serializedScriptSig);

          expect(deserializedScriptSig, isA<ScriptSig>());
          expect(
            deserializedScriptSig.length.value,
            scriptSig.length.value,
          );
          expect(deserializedScriptSig.type, scriptSig.type);
          expect(deserializedScriptSig.commands, scriptSig.commands);
        });
      });

      group('with uncompressed SEC pubKey', () {
        test('with valid bytes', () {
          final signature = List<int>.filled(65, 10);
          final scriptSig = ScriptSig.forP2PK(signature);
          final serializedScriptSig = scriptSig.serialize();
          final deserializedScriptSig =
              ScriptSig.deserialize(serializedScriptSig);

          expect(deserializedScriptSig, isA<ScriptSig>());
          expect(
            deserializedScriptSig.length.value,
            scriptSig.length.value,
          );
          expect(deserializedScriptSig.type, scriptSig.type);
          expect(deserializedScriptSig.commands, scriptSig.commands);
        });
      });
    });
    group('with p2pkh bytes', () {
      test('with valid bytes', () {
        final signature = List<int>.filled(74, 10);
        final pubKey = List<int>.filled(65, 10);
        final scriptSig = ScriptSig.forP2PKH(signature, pubKey);
        final serializedScriptSig = scriptSig.serialize();
        final deserializedScriptSig =
            ScriptSig.deserialize(serializedScriptSig);

        expect(deserializedScriptSig, isA<ScriptSig>());
        expect(
          deserializedScriptSig.length.value,
          scriptSig.length.value,
        );
        expect(deserializedScriptSig.type, scriptSig.type);
        expect(deserializedScriptSig.commands, scriptSig.commands);
      });
    });
  });
}
