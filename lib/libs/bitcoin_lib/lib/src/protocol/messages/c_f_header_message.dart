import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../types/bases/uint32le.dart';
import '../types/filter_type.dart';
import '../types/hash256.dart';
import '../types/var_hashes.dart';

@immutable
class CFHeadersMessage {
  const CFHeadersMessage({
    required this.filterType,
    required this.stopHash,
    required this.filterHashes,
  });

  factory CFHeadersMessage.deserialize(Uint8List bytes) {
    var startIndex = 0;
    final filterType = FilterType.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + FilterType.bytesLength(),
      ),
    );
    startIndex += FilterType.bytesLength();

    final stopHash = Hash256.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Hash256.bytesLength(),
      ),
    );
    startIndex += Hash256.bytesLength();

    final filterHashes = VarHashes.deserialize(
      bytes.sublist(startIndex),
    );
    startIndex += Uint32le.bytesLength();

    return CFHeadersMessage(
      filterType: filterType,
      stopHash: stopHash,
      filterHashes: filterHashes,
    );
  }

  final FilterType filterType;
  final Hash256 stopHash;
  final VarHashes filterHashes;

  Uint8List serialize() {
    return Uint8List.fromList([
      ...filterType.serialize(),
      ...stopHash.serialize(),
      ...filterHashes.serialize(),
    ]);
  }

  int bytesLength() {
    return FilterType.bytesLength() +
        Uint32le.bytesLength() +
        Hash256.bytesLength();
  }

  Map<String, dynamic> toJson() => {
        'filterType': filterType.toJson(),
        'stopHash': stopHash.toJson(),
        'filterHashes': filterHashes.toJson(),
      };
}