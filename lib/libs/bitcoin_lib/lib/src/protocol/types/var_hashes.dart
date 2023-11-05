import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'hash256.dart';
import 'variable_length_integer.dart';

@immutable
class VarHashes {
  factory VarHashes(List<Hash256> hashes) {
    final length = VarInt(hashes.length);
    if (length.value > 2000) {
      throw Exception('VarHashes cannot have more than 2000 hashes');
    }
    return VarHashes._internal(length, hashes);
  }

  factory VarHashes.deserialize(Uint8List inputBytes) {
    var startIndex = 0;
    final length = VarInt.deserialize(inputBytes);

    startIndex += length.bytesLength();

    final hashBytes = <Hash256>[];

    for (var i = 0; i < length.value; i++) {
      final hash = Hash256.deserialize(
        inputBytes.sublist(
          startIndex,
          startIndex + Hash256.bytesLength(),
        ),
      );
      hashBytes.add(hash);
      startIndex += Hash256.bytesLength();
    }

    return VarHashes(hashBytes);
  }

  const VarHashes._internal(this.length, this.hashes);

  final VarInt length;
  final List<Hash256> hashes;

  int bytesLength() => length.length + length.value;

  Map<String, dynamic> toJson() => {
        'hashes': [for (final hash in hashes) hash.toJson()]
      };

  Uint8List serialize() {
    final byteList = [
      ...length.serialize(),
      for (final hash in hashes) ...hash.serialize(),
    ];

    return Uint8List.fromList(byteList);
  }
}
