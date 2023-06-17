import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../types/bases/uint32le.dart';
import '../types/filter_type.dart';
import '../types/hash256.dart';

@immutable
class GetCFHeadersMessage {
  const GetCFHeadersMessage({
    required this.filterType,
    required this.startHeight,
    required this.stopHash,
  });

  factory GetCFHeadersMessage.deserialize(Uint8List bytes) {
    var startIndex = 0;
    final filterType = FilterType.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + FilterType.bytesLength(),
      ),
    );
    startIndex += FilterType.bytesLength();

    final startHeight = Uint32le.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Uint32le.bytesLength(),
      ),
    );
    startIndex += Uint32le.bytesLength();

    final stopHash = Hash256.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Hash256.bytesLength(),
      ),
    );
    startIndex += Hash256.bytesLength();

    return GetCFHeadersMessage(
      filterType: filterType,
      startHeight: startHeight,
      stopHash: stopHash,
    );
  }

  final FilterType filterType;
  final Uint32le startHeight;
  final Hash256 stopHash;

  Uint8List serialize() {
    return Uint8List.fromList([
      ...filterType.serialize(),
      ...startHeight.serialize(),
      ...stopHash.serialize(),
    ]);
  }

  int bytesLength() {
    return FilterType.bytesLength() +
        Uint32le.bytesLength() +
        Hash256.bytesLength();
  }

  Map<String, dynamic> toJson() => {
        'filterType': filterType.toJson(),
        'startHeight': startHeight.toJson(),
        'stopHash': stopHash.toJson(),
      };
}
