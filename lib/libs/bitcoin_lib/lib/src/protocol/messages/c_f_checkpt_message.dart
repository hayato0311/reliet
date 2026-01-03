import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../types/bases/uint32le.dart';
import '../types/filter_type.dart';
import '../types/hash256.dart';
import '../types/var_hashes.dart';

@immutable
class CFCheckptMessage {
  const CFCheckptMessage({
    required this.filterType,
    required this.stopHash,
    required this.filterHeaders,
  });

  factory CFCheckptMessage.deserialize(Uint8List bytes) {
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

    final filterHeaders = VarHashes.deserialize(
      bytes.sublist(startIndex),
    );
    startIndex += Uint32le.bytesLength();

    return CFCheckptMessage(
      filterType: filterType,
      stopHash: stopHash,
      filterHeaders: filterHeaders,
    );
  }

  final FilterType filterType;
  final Hash256 stopHash;
  final VarHashes filterHeaders;

  int bytesLength() {
    return FilterType.bytesLength() +
        Uint32le.bytesLength() +
        filterHeaders.bytesLength();
  }

  Uint8List serialize() {
    return Uint8List.fromList([
      ...filterType.serialize(),
      ...stopHash.serialize(),
      ...filterHeaders.serialize(),
    ]);
  }

  Map<String, dynamic> toJson() => {
        'filterType': filterType.toJson(),
        'stopHash': stopHash.toJson(),
        'filterHeaders': filterHeaders.toJson(),
      };
}
