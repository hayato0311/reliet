import 'dart:convert';
import 'dart:typed_data';

import 'variable_length_integer.dart';

class VarStr {
  VarStr(this.string) {
    length = VarInt(string.length);
  }
  late final VarInt length;
  final String string;

  Uint8List serialize() {
    final byteList = length.serialize().toList();

    if (string.isNotEmpty) {
      byteList.addAll(utf8.encode(string));
    }

    return Uint8List.fromList(byteList);
  }
}
