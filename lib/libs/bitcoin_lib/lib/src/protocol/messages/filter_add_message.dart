import 'dart:typed_data';

import 'package:meta/meta.dart';

@immutable
class FilterAddMessage {
  const FilterAddMessage(this.data);

  factory FilterAddMessage.deserialize(Uint8List bytes) =>
      FilterAddMessage(Uint8List.fromList(bytes.reversed.toList()));

  final Uint8List data;

  int bytesLength() => data.length;

  Map<String, dynamic> toJson() => {'bytes': data.toList()};

  Uint8List serialize() => Uint8List.fromList(data.reversed.toList());
}
