import "dart:typed_data";

import 'hash.dart';

class Checksum {
  late final Uint8List value;

  Checksum._internal(this.value);

  factory Checksum.fromPayload(Uint8List payload) {
    final checksum = Uint8List.fromList(hash256(payload).bytes.sublist(0, 4));

    return Checksum._internal(checksum);
  }
}
