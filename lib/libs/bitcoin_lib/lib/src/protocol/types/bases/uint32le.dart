import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../../extensions/int_extensions.dart';

@immutable
class Uint32le {
  factory Uint32le(int value) {
    if (value > 0xffffffff) {
      throw RangeError(
        'Given value is out of range. Set 0xffffffff or less value',
      );
    }
    return Uint32le._internal(value);
  }

  factory Uint32le.deserialize(Uint8List bytes) =>
      Uint32le(CreateInt.fromUint32leBytes(bytes));

  const Uint32le._internal(this.value);

  static int bytesLength() => 4;

  final int value;

  Map<String, dynamic> toJson() => {'value': value};

  Uint8List serialize() => value.toUint32leBytes();
}
