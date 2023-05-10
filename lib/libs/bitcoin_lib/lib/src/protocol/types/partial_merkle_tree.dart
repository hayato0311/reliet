import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../types/bases/uint32le.dart';
import '../types/hash256.dart';
import 'variable_length_integer.dart';

@immutable
class PartialMerkleTree {
  const PartialMerkleTree._internal(
    this.nTxs,
    this.hashCount,
    this.hashes,
  );

  factory PartialMerkleTree.deserialize(Uint8List bytes) {
    var startIndex = 0;
    final nTxs = Uint32le.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Uint32le.bytesLength(),
      ),
    );
    startIndex += Uint32le.bytesLength();

    final hashCount = VarInt.deserialize(
      bytes.sublist(startIndex),
    );
    startIndex += hashCount.bytesLength();

    final hashes = <Hash256>[];
    for (var i = 0; i < hashCount.value; i++) {
      final hash = Hash256.deserialize(
        bytes.sublist(
          startIndex,
          startIndex + Hash256.bytesLength(),
        ),
      );
      hashes.add(hash);
    }
    startIndex += Hash256.bytesLength() * hashCount.value;

    return PartialMerkleTree._internal(
      nTxs,
      hashCount,
      hashes,
    );
  }

  final Uint32le nTxs;
  final VarInt hashCount;
  final List<Hash256> hashes;

  int bytesLength() {
    return Uint32le.bytesLength() +
        Uint32le.bytesLength() +
        hashCount.value * Hash256.bytesLength();
  }

  Map<String, dynamic> toJson() => {
        'nTxs': nTxs.toJson(),
        'hashCount': hashCount.toJson(),
        'hashes': [for (var hash in hashes) hash.toJson()],
      };
}
