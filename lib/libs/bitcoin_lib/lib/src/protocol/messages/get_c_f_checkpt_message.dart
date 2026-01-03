import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../types/filter_type.dart';
import '../types/hash256.dart';

@immutable
class GetCFCheckptMessage {
  const GetCFCheckptMessage({
    required this.filterType,
    required this.stopHash,
  });

  factory GetCFCheckptMessage.deserialize(Uint8List bytes) {
    if (bytes.length != bytesLength()) {
      throw ArgumentError('''
GetCFCheckptMessage.deserialize:
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

    final stopHash = Hash256.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Hash256.bytesLength(),
      ),
    );
    startIndex += Hash256.bytesLength();

    return GetCFCheckptMessage(
      filterType: filterType,
      stopHash: stopHash,
    );
  }

  final FilterType filterType;
  final Hash256 stopHash;

  static int bytesLength() {
    return FilterType.bytesLength() + Hash256.bytesLength();
  }

  Uint8List serialize() {
    return Uint8List.fromList([
      ...filterType.serialize(),
      ...stopHash.serialize(),
    ]);
  }

  Map<String, dynamic> toJson() => {
        'filterType': filterType.toJson(),
        'stopHash': stopHash.toJson(),
      };
}
