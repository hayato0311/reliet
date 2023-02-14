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
    final headByte = bytes[0];
    final varIntBytesLength = VarInt.bytesLength(headByte);

    if (bytes.length < varIntBytesLength) {
      throw ArgumentError('The length of given bytes is invalid');
    }

    final length = VarInt.deserialize(bytes.sublist(0, varIntBytesLength));

    final stringBytes = bytes.sublist(varIntBytesLength);

    if (stringBytes.length != length.value) {
      throw ArgumentError('The given bytes is invalid');
    }

    return VarStr(utf8.decode(stringBytes));
  }

  static int bytesLength(VarInt varInt) {
    return varInt.length + varInt.value;
  }

  late final VarInt length;
  final String string;

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
