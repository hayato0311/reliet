import 'dart:typed_data';

import 'package:collection/collection.dart';

import '../../utils/hash.dart';

class Checksum {
  Checksum._internal(this.bytes);
  factory Checksum.fromPayload(Uint8List payload) {
    final checksum = Uint8List.fromList(hash256(payload).bytes.sublist(0, 4));

    return Checksum._internal(checksum);
  }

  static int bytesLength() => 4;

  bool isValid(Uint8List checksum) => checksum.equals(bytes);

  late final Uint8List bytes;

  Uint8List serialize() => bytes;
}
