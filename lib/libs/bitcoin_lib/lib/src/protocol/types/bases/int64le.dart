import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../../extensions/int_extensions.dart';

@immutable
class Int64le {
  factory Int64le(int value) {
    return Int64le._internal(value);
  }

  factory Int64le.deserialize(Uint8List bytes) =>
      Int64le(CreateInt.fromInt64leBytes(bytes));

  const Int64le._internal(this.value);

  static int bytesLength() => 8;

  final int value;

  Map<String, dynamic> toJson() => {'value': value};

  Uint8List serialize() => value.toInt64leBytes();
}
