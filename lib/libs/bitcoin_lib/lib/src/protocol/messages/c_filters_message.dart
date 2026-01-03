import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../types/bases/uint32le.dart';
import '../types/filter_type.dart';
import '../types/hash256.dart';
import '../types/var_bytes.dart';

@immutable
class CFiltersMessage {
  const CFiltersMessage({
    required this.filterType,
    required this.blockHash,
    required this.filterBytes,
  });

  factory CFiltersMessage.deserialize(Uint8List bytes) {
    var startIndex = 0;
    final filterType = FilterType.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + FilterType.bytesLength(),
      ),
    );
    startIndex += FilterType.bytesLength();

    final blockHash = Hash256.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Hash256.bytesLength(),
      ),
    );
    startIndex += Hash256.bytesLength();

    final filterBytes = VarBytes.deserialize(
      bytes.sublist(startIndex),
    );
    startIndex += filterBytes.bytesLength();

    return CFiltersMessage(
      filterType: filterType,
      blockHash: blockHash,
      filterBytes: filterBytes,
    );
  }

  final FilterType filterType;
  final Hash256 blockHash;
  final VarBytes filterBytes;

  int bytesLength() {
    return FilterType.bytesLength() +
        Uint32le.bytesLength() +
        filterBytes.bytesLength();
  }

  Uint8List serialize() {
    return Uint8List.fromList([
      ...filterType.serialize(),
      ...blockHash.serialize(),
      ...filterBytes.serialize(),
    ]);
  }

  Map<String, dynamic> toJson() => {
        'filterType': filterType.toJson(),
        'blockHash': blockHash.toJson(),
        'filterBytes': filterBytes.toJson(),
      };
}
