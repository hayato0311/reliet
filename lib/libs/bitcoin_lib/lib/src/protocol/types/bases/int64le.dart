import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../../extensions/int_extensions.dart';

@immutable
class Int64le {
  const Int64le(this.value);

  factory Int64le.deserialize(Uint8List bytes) =>
      Int64le(CreateInt.fromInt64leBytes(bytes));

  static int bytesLength() => 8;

  final int value;

  Map<String, dynamic> toJson() => {'value': value};

  Uint8List serialize() => value.toInt64leBytes();
}
