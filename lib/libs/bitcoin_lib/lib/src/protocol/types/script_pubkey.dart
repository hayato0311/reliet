import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'op_code.dart';
import 'script.dart';
import 'script_type.dart';
import 'variable_length_integer.dart';

@immutable
class ScriptPubKey extends Script {
  const ScriptPubKey._internal(super.length, super.commands, super.type);

  factory ScriptPubKey.deserialize(Uint8List bytes) {
    final script = Script.deserialize(bytes);
    return ScriptPubKey._internal(
      script.length,
      script.commands,
      checkType(script.commands),
    );
  }

  factory ScriptPubKey.forP2PK(List<int> pubKey) {
    if (pubKey.length != 33 && pubKey.length != 65) {
      throw ArgumentError('pubKey must be 33 or 65 bytes');
    }
    final commands = <dynamic>[];
    commands.add(OpCode.deserialize(Uint8List.fromList([pubKey.length])));
    commands.add(pubKey);
    commands.add(OpCode.opCheckSig);
    return ScriptPubKey._internal(
      VarInt(pubKey.length + 2),
      commands,
      ScriptType.p2pk,
    );
  }

  factory ScriptPubKey.forP2PKH(List<int> pubKeyHash) {
    final commands = <dynamic>[];
    commands.add(OpCode.opDup);
    commands.add(OpCode.opHash160);
    commands.add(OpCode.opPushBytes20); // length of pubKeyHash (hash160)
    commands.add(pubKeyHash);
    commands.add(OpCode.opEqualVerify);
    commands.add(OpCode.opCheckSig);
    return ScriptPubKey._internal(VarInt(25), commands, ScriptType.p2pkh);
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
    return ScriptType.unsupported;
  }

  static bool isP2PK(List<dynamic> commands) {
    if (!(commands[0] == OpCode.opPushBytes33 ||
        commands[0] == OpCode.opPushBytes65)) {
      return false;
    }
    final pubKeyLength = (commands[0] as OpCode).value;
    if (commands[1] is! List<int>) {
      return false;
    }
    if ((commands[1] as List<int>).length != pubKeyLength) {
      return false;
    }
    if (commands[2] != OpCode.opCheckSig) {
      return false;
    }
    return true;
  }

  static bool isP2PKH(List<dynamic> commands) {
    if (commands[0] != OpCode.opDup) {
      return false;
    }
    if (commands[1] != OpCode.opHash160) {
      return false;
    }
    if (commands[2] != OpCode.opPushBytes20) {
      return false;
    }
    if (commands[3] is! List<int>) {
      return false;
    }
    if ((commands[3] as List<int>).length != 20) {
      return false;
    }
    if (commands[4] != OpCode.opEqualVerify) {
      return false;
    }
    if (commands[5] != OpCode.opCheckSig) {
      return false;
    }
    return true;
  }
}

bool isOpPushBytes(OpCode command) {
  return command.value >= 1 && command.value <= 75;
}
