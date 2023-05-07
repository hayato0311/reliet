import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'op_code.dart';
import 'script.dart';
import 'script_type.dart';
import 'variable_length_integer.dart';

@immutable
class ScriptSig extends Script {
  const ScriptSig._internal(super.length, super.commands, super.type);

  factory ScriptSig.deserialize(Uint8List bytes) {
    final script = Script.deserialize(bytes);
    return ScriptSig._internal(
      script.length,
      script.commands,
      checkType(script.commands),
    );
  }

  factory ScriptSig.forP2PK(List<int> signature) {
    if (signature.isEmpty || signature.length > 75) {
      throw ArgumentError('signature must be 1 to 75 bytes');
    }
    final commands = <dynamic>[];
    commands.add(OpCode.deserialize(Uint8List.fromList([signature.length])));
    commands.add(signature);
    return ScriptSig._internal(
      VarInt(signature.length + 1),
      commands,
      ScriptType.p2pk,
    );
  }

  factory ScriptSig.forP2PKH(
    List<int> signature,
    List<int> pubKey,
  ) {
    if (signature.isEmpty || signature.length > 75) {
      throw ArgumentError('signature must be 1 to 75 bytes');
    }
    if (pubKey.length != 33 && pubKey.length != 65) {
      throw ArgumentError('pubKey must be 33 or 65 bytes');
    }
    final commands = <dynamic>[];
    commands.add(OpCode.deserialize(Uint8List.fromList([signature.length])));
    commands.add(signature);
    commands.add(OpCode.deserialize(Uint8List.fromList([pubKey.length])));
    commands.add(pubKey);

    return ScriptSig._internal(
      VarInt(signature.length + pubKey.length + 2),
      commands,
      ScriptType.p2pkh,
    );
  }

  static ScriptType checkType(List<dynamic> commands) {
    if (commands.isEmpty) {
      return ScriptType.empty;
    }
    if (isP2PKH(commands)) {
      return ScriptType.p2pkh;
    }
    if (isP2PK(commands)) {
      return ScriptType.p2pk;
    }
    // TODO: add support for other script types, then raise exception
    // throw ArgumentError('Unsupported script type');
    return ScriptType.unsupported;
  }

  static bool isP2PK(List<dynamic> commands) {
    if (commands.length != 2) {
      return false;
    }
    if (commands[0] is! OpCode) {
      return false;
    }
    final signatureLength = (commands[0] as OpCode).value;
    if (signatureLength < 1 || signatureLength > 75) {
      return false;
    }
    if (commands[1] is! List<int>) {
      return false;
    }
    final signature = commands[1] as List<int>;
    if (signature.length != signatureLength) {
      return false;
    }
    return true;
  }

  static bool isP2PKH(List<dynamic> commands) {
    if (commands.length != 4) {
      return false;
    }
    if (commands[0] is! OpCode) {
      return false;
    }
    final signatureLength = (commands[0] as OpCode).value;
    if (signatureLength < 1 || signatureLength > 75) {
      return false;
    }
    if (commands[1] is! List<int>) {
      return false;
    }
    final signature = commands[1] as List<int>;
    if (signature.length != signatureLength) {
      return false;
    }
    if (!(commands[2] == OpCode.opPushBytes33 ||
        commands[2] == OpCode.opPushBytes65)) {
      return false;
    }
    final pubKeyLength = (commands[2] as OpCode).value;
    if (commands[3] is! List<int>) {
      return false;
    }
    if ((commands[3] as List<int>).length != pubKeyLength) {
      return false;
    }
    return true;
  }
}
