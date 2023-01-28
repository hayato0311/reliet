import 'dart:typed_data';
import 'dart:math';

import '../../utils/encode.dart';

class StartHeight {
  final int value;

  StartHeight._internal(this.value);

  factory StartHeight(int value) {
    if (value > 0x7fffffff) {
      throw RangeError(
        "Given value is out of range. Set less than 0x7fffffff",
      );
    }
    return StartHeight._internal(value);
  }

  Uint8List serialize() => int32leBytes(value);
}
