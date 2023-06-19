import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../types/bases/uint32le.dart';
import '../types/filter_type.dart';
import '../types/hash256.dart';

@immutable
class GetCFilterMessage {
  const GetCFilterMessage({
    required this.filterType,
    required this.startHeight,
    required this.stopHash,
  });

  factory GetCFilterMessage.deserialize(Uint8List bytes) {
    if (bytes.length != bytesLength()) {
      throw ArgumentError('''
GetCFilterMessage.deserialize:
The length of given bytes is invalid
Expected: ${bytesLength()}, Actual: ${bytes.length}
''');
    }

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

    return GetCFilterMessage(
      filterType: filterType,
      startHeight: startHeight,
      stopHash: stopHash,
    );
  }

  final FilterType filterType;
  final Uint32le startHeight;
  final Hash256 stopHash;

  static int bytesLength() {
    return FilterType.bytesLength() +
        Uint32le.bytesLength() +
        Hash256.bytesLength();
  }

  Uint8List serialize() {
    return Uint8List.fromList([
      ...filterType.serialize(),
      ...startHeight.serialize(),
      ...stopHash.serialize(),
    ]);
  }

  Map<String, dynamic> toJson() => {
        'filterType': filterType.toJson(),
        'startHeight': startHeight.toJson(),
        'stopHash': stopHash.toJson(),
      };
}
