import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'variable_length_integer.dart';

@immutable
class VarBytes {
  factory VarBytes(Uint8List bytes) {
    final length = VarInt(bytes.length);
    return VarBytes._internal(length, bytes);
  }

  const VarBytes._internal(this.length, this.bytes);

  factory VarBytes.deserialize(Uint8List inputBytes) {
    final length = VarInt.deserialize(inputBytes);

    final bytes = inputBytes.sublist(
      length.bytesLength(),
      length.bytesLength() + length.value,
    );

    return VarBytes(Uint8List.fromList(bytes.reversed.toList()));
  }

  final VarInt length;
  final Uint8List bytes;

  int bytesLength() => length.length + length.value;

  Map<String, dynamic> toJson() => {'bytes': bytes.toList()};

  Uint8List serialize() {
    final byteList = length.serialize().toList();

    if (bytes.isNotEmpty) {
      byteList.addAll(bytes.reversed);
    }

    return Uint8List.fromList(byteList);
  }
}
