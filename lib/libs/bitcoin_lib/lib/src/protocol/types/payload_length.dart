import 'dart:typed_data';

import '../../utils/encode.dart';

class PayloadLength {
  factory PayloadLength(int value) {
    if (value > 0xffffffff) {
      throw RangeError(
        'Given value is out of range. Set 0xffffffff or less value',
      );
    }
    return PayloadLength._internal(value);
  }

  PayloadLength._internal(this.value);
  final int value;

  Uint8List serialize() => uint32leBytes(value);
}
