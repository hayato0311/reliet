import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'bases/uint32le.dart';
import 'hash256.dart';

@immutable
class TxOutPoint {
  const TxOutPoint(this.hash, this.index);

  factory TxOutPoint.deserialize(Uint8List bytes) {
    var startIndex = 0;
    final hash = Hash256.deserialize(
      bytes.sublist(startIndex, startIndex + Hash256.bytesLength()),
    );
    startIndex += Hash256.bytesLength();

    final index = Uint32le.deserialize(
      bytes.sublist(startIndex, startIndex + Uint32le.bytesLength()),
    );

    startIndex += Uint32le.bytesLength();

    if (bytes.length != startIndex) {
      throw ArgumentError('''
The length of given bytes is invalid.
Expected: ${bytesLength()}, Actual: ${bytes.length}''');
    }

    return TxOutPoint(hash, index);
  }

  static int bytesLength() => Hash256.bytesLength() + Uint32le.bytesLength();

  final Hash256 hash;
  final Uint32le index;

  Map<String, dynamic> toJson() =>
      {'hash': hash.toJson(), 'index': index.toJson()};

  Uint8List serialize() {
    final byteList = <int>[
      ...hash.serialize(),
      ...index.serialize(),
    ];

    return Uint8List.fromList(byteList);
  }

  bool isCoinBase() {
    return hash.bytes.every((element) => element == 0) &&
        index.value == 0xffffffff;
  }
}
