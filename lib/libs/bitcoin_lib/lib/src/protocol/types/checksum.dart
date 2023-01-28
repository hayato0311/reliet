import "dart:typed_data";

import '../../utils/hash.dart';

class Checksum {
  late final Uint8List bytes;

  Checksum._internal(this.bytes);

  factory Checksum.fromPayload(Uint8List payload) {
    final checksum = Uint8List.fromList(hash256(payload).bytes.sublist(0, 4));

    return Checksum._internal(checksum);
  }

  Uint8List serialize() => bytes;
}
