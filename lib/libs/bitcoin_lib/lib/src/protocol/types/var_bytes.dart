import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'variable_length_integer.dart';

@immutable
class VarBytes {
  factory VarBytes(List<int> bytes) {
    final length = VarInt(bytes.length);
    return VarBytes._internal(length, bytes);
  }

  const VarBytes._internal(this.length, this.bytes);

  factory VarBytes.deserialize(Uint8List bytes) =>
      VarBytes(Uint8List.fromList(bytes.reversed.toList()));

  final VarInt length;
  final List<int> bytes;

  int bytesLength() => length.length + length.value;

  Map<String, dynamic> toJson() => {'bytes': bytes};

  Uint8List serialize() => Uint8List.fromList(bytes.reversed.toList());
}
