import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'hash256.dart';

@immutable
class Checksum {
  const Checksum._internal(this.bytes);
  factory Checksum.fromPayload(Uint8List payload) {
    final checksum =
        Uint8List.fromList(Hash256.create(payload).bytes.sublist(0, 4));

    return Checksum._internal(checksum);
  }

  static int bytesLength() => 4;

  bool isValid(Uint8List checksum) => checksum.equals(bytes);

  final Uint8List bytes;

  Map<String, dynamic> toJson() => {'bytes': bytes};

  Uint8List serialize() => bytes;
}
