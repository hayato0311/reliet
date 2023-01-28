import 'dart:typed_data';

import '../../encode.dart';

class PayloadLength {
  final int value;

  PayloadLength._internal(this.value);

  factory PayloadLength(int value) {
    if (value > 0xffffffff) {
      throw RangeError(
        "Given value is out of range. Set 0xffffffff or less value",
      );
    }
    return PayloadLength._internal(value);
  }

  Uint8List serialize() => uint32leBytes(value);
}
