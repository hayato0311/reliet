import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../extensions/int_extensions.dart';
import 'op_code.dart';
import 'script_pubkey.dart';
import 'script_sig.dart';
import 'script_type.dart';
import 'variable_length_integer.dart';

@immutable
class Script {
  const Script(this.length, this.commands, this.type);

  // ignore: prefer_constructors_over_static_methods
  static Script deserialize(Uint8List bytes) {
    final commands = <dynamic>[];

    final length = VarInt.deserialize(bytes);

    if (bytes.length < length.length + length.value) {
      throw ArgumentError('The given bytes is too short');
    }

    var startIndex = length.length;

    while (startIndex < length.length + length.value) {
      final opCode = OpCode.deserialize(
        bytes.sublist(
          startIndex,
          startIndex + OpCode.bytesLength(),
        ),
      );
      startIndex += OpCode.bytesLength();
      if (opCode.value >= 1 && opCode.value <= 75) {
        // opPushBytes
        commands.add(opCode);
        commands.add(
          bytes.sublist(
            startIndex,
            startIndex + opCode.value,
          ),
        );
        startIndex += opCode.value;
      } else if (opCode == OpCode.opPushData1) {
        final pushData1Length = CreateInt.fromUint8Bytes(
          bytes.sublist(
            startIndex,
            startIndex + 1,
          ),
        );
        startIndex += 1;
        commands.add(
          bytes.sublist(
            startIndex,
            startIndex + pushData1Length,
          ),
        );
        startIndex += pushData1Length;
      } else if (opCode == OpCode.opPushData2) {
        final pushData2Length = CreateInt.fromUint16leBytes(
          bytes.sublist(
            startIndex,
            startIndex + 2,
          ),
        );
        startIndex += 2;
        commands.add(
          bytes.sublist(
            startIndex,
            startIndex + pushData2Length,
          ),
        );
        startIndex += pushData2Length;
      } else if (opCode == OpCode.opPushData4) {
        final pushData4Length = CreateInt.fromUint32leBytes(
          bytes.sublist(
            startIndex,
            startIndex + 4,
          ),
        );
        startIndex += 4;
        commands.add(
          bytes.sublist(
            startIndex,
            startIndex + pushData4Length,
          ),
        );
        startIndex += pushData4Length;
      } else {
        commands.add(opCode);
      }
    }

    if (startIndex != length.length + length.value) {
      throw ArgumentError('The given bytes is invalid');
    }
    return Script(length, commands, null);
  }

  Script operator +(Script other) {
    if (type != other.type) {
      throw ArgumentError('The given script type is not same');
    }
    if (this is ScriptPubKey && other is ScriptPubKey) {
      throw ArgumentError('The given script type is not same');
    }
    if (this is ScriptSig && other is ScriptSig) {
      throw ArgumentError('The given script type is not same');
    }
    if (!(this is ScriptPubKey || this is ScriptSig)) {
      throw ArgumentError('This is not ScriptPubKey or ScriptSig');
    }
    if (!(other is ScriptPubKey || other is ScriptSig)) {
      throw ArgumentError('This is not ScriptPubKey or ScriptSig');
    }

    final combinedCommands = this is ScriptSig
        ? [
            ...commands,
            ...other.commands,
          ]
        : [
            ...other.commands,
            ...commands,
          ];

    return Script(
      VarInt(length.value + other.length.value),
      combinedCommands,
      type,
    );
  }

  final VarInt length;
  final List<dynamic> commands;
  final ScriptType? type;

  int bytesLength() {
    return length.length + length.value;
  }

  Map<String, dynamic> toJson() => {
        'length': length.toJson(),
        'commands': commands.toString(),
        'type': type.toString(),
      };

  Uint8List serialize() {
    final byteList = <int>[
      ...length.serialize(),
      ..._serializeCommands(commands),
    ];

    return Uint8List.fromList(byteList);
  }

  List<int> _serializeCommands(List<dynamic> commands) {
    final byteList = <int>[];

    for (final command in commands) {
      if (command is OpCode) {
        byteList.addAll(command.serialize());
      } else if (command is List<int>) {
        if (command.isNotEmpty && command.length <= 75) {
          byteList.addAll(command);
        } else if (command.length >= 76 && command.length <= 255) {
          // OpCode.opPushData1
          byteList.addAll(command);
        } else if (command.length >= 256 && command.length <= 65535) {
          // OpCode.opPushData2
          byteList.addAll(command);
        } else if (command.length >= 65536 && command.length <= 4294967295) {
          // OpCode.opPushData4
          byteList.addAll(command);
        } else {
          throw ArgumentError('The given command is too long');
        }
      } else {
        throw ArgumentError('The given command is unexpected type');
      }
    }
    return byteList;
  }
}
