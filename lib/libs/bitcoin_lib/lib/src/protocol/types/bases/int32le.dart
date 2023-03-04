import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../../extensions/int_extensions.dart';

@immutable
class Int32le {
  factory Int32le(int value) {
    if (value > 0x7fffffff) {
      throw RangeError(
        'Given value is out of range. Set less than 0x7fffffff',
      );
    }
    return Int32le._internal(value);
  }

  factory Int32le.deserialize(Uint8List bytes) =>
      Int32le(CreateInt.fromInt32leBytes(bytes));

  const Int32le._internal(this.value);

  static int bytesLength() => 4;

  final int value;

  Map<String, dynamic> toJson() => {'value': value};

  Uint8List serialize() => value.toInt32leBytes();
}
