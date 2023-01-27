import 'dart:convert';
import 'dart:typed_data';

import 'variable_length_integer.dart';

class VarStr {
  late final VarInt length;
  final String string;

  VarStr(this.string) {
    length = VarInt(string.length);
  }

  Uint8List serialize() {
    List<int> byteList = length.serialize().toList();

    if (string.isNotEmpty) {
      byteList.addAll(utf8.encode(string));
    }

    return Uint8List.fromList(byteList);
  }
}
