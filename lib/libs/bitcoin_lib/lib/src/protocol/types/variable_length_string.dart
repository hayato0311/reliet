import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'variable_length_integer.dart';

@immutable
class VarStr {
  VarStr(this.string) {
    length = VarInt(string.length);
  }

  factory VarStr.deserialize(Uint8List bytes) {
    final length = VarInt.deserialize(bytes);

    final stringBytes = bytes.sublist(
      length.bytesLength(),
      length.bytesLength() + length.value,
    );

    return VarStr(utf8.decode(stringBytes));
  }

  late final VarInt length;
  final String string;

  int bytesLength() {
    return length.length + string.length;
  }

  Map<String, dynamic> toJson() =>
      {'length': length.toJson(), 'string': string};

  Uint8List serialize() {
    final byteList = length.serialize().toList();

    if (string.isNotEmpty) {
      byteList.addAll(utf8.encode(string));
    }

    return Uint8List.fromList(byteList);
  }
}
