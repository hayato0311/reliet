import 'dart:typed_data';

import 'package:meta/meta.dart';

@immutable
class Filter {
  const Filter(this.bytes);

  factory Filter.deserialize(Uint8List bytes) =>
      Filter(Uint8List.fromList(bytes.reversed.toList()));

  final Uint8List bytes;

  int bytesLength() => bytes.length;

  Map<String, dynamic> toJson() => {'bytes': bytes.toList()};

  Uint8List serialize() => Uint8List.fromList(bytes.reversed.toList());
}
