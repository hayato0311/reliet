import 'dart:typed_data';

import '../../utils/hash.dart';

class Checksum {
  Checksum._internal(this.bytes);
  factory Checksum.fromPayload(Uint8List payload) {
    final checksum = Uint8List.fromList(hash256(payload).bytes.sublist(0, 4));

    return Checksum._internal(checksum);
  }

  late final Uint8List bytes;

  Uint8List serialize() => bytes;
}
