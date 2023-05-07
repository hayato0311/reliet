import 'dart:typed_data';

import 'package:meta/meta.dart';

@immutable
class BloomFilter {
  const BloomFilter(this.bytes);

  factory BloomFilter.deserialize(Uint8List bytes) =>
      BloomFilter(Uint8List.fromList(bytes.reversed.toList()));

  final Uint8List bytes;

  int bytesLength() => bytes.length;

  Map<String, dynamic> toJson() => {'bytes': bytes.toList()};

  Uint8List serialize() => Uint8List.fromList(bytes.reversed.toList());
}
