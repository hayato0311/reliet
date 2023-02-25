import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'hash256.dart';
import 'tx_out_point_index.dart';

@immutable
class TxOutPoint {
  const TxOutPoint(this.hash, this.index);

  factory TxOutPoint.deserialize(Uint8List bytes) {
    var startIndex = 0;
    final hash = Hash256.deserialize(
      bytes.sublist(startIndex, startIndex + Hash256.bytesLength()),
    );
    startIndex += Hash256.bytesLength();

    final index = TxOutPointIndex.deserialize(
      bytes.sublist(startIndex, startIndex + TxOutPointIndex.bytesLength()),
    );

    startIndex += TxOutPointIndex.bytesLength();

    if (bytes.length != startIndex) {
      throw ArgumentError('''
The length of given bytes is invalid.
Expected: ${bytesLength()}, Actual: ${bytes.length}''');
    }

    return TxOutPoint(hash, index);
  }

  static int bytesLength() =>
      Hash256.bytesLength() + TxOutPointIndex.bytesLength();

  final Hash256 hash;
  final TxOutPointIndex index;

  Map<String, dynamic> toJson() =>
      {'hash': hash.toJson(), 'index': index.toJson()};

  Uint8List serialize() {
    final byteList = <int>[
      ...hash.serialize(),
      ...index.serialize(),
    ];

    return Uint8List.fromList(byteList);
  }
}
