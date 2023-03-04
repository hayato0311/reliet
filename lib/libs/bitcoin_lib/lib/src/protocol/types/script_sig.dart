import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'variable_length_integer.dart';

@immutable
class ScriptSig {
  ScriptSig(this.bytes) {
    length = VarInt(bytes.length);
  }

  factory ScriptSig.deserialize(Uint8List bytes) {
    final length = VarInt.deserialize(bytes);

    final stringBytes = bytes.sublist(
      length.bytesLength(),
      length.bytesLength() + length.value,
    );

    return ScriptSig(stringBytes);
  }

  late final VarInt length;
  final List<int> bytes;

  int bytesLength() {
    return length.length + bytes.length;
  }

  Map<String, dynamic> toJson() => {'length': length.toJson(), 'bytes': bytes};

  Uint8List serialize() {
    final byteList = length.serialize().toList();

    if (bytes.isNotEmpty) {
      byteList.addAll(bytes);
    }

    return Uint8List.fromList(byteList);
  }
}
