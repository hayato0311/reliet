import 'dart:typed_data';

import '../../extensions/int_extensions.dart';

class PayloadLength {
  factory PayloadLength(int value) {
    if (value > 0xffffffff) {
      throw RangeError(
        'Given value is out of range. Set 0xffffffff or less value',
      );
    }
    return PayloadLength._internal(value);
  }

  factory PayloadLength.deserialize(Uint8List bytes) =>
      PayloadLength(CreateInt.fromUint32leBytes(bytes));

  PayloadLength._internal(this.value);

  static int bytesLength() => 4;

  final int value;

  Map<String, dynamic> toJson() => {'value': value};

  Uint8List serialize() => value.toUint32leBytes();
}
