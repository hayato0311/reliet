import 'dart:typed_data';
import 'dart:math';

import '../../encode.dart';

class StartHeight {
  final int value;

  StartHeight._internal(this.value);

  factory StartHeight(int value) {
    if (value > pow(2, 31) - 1) {
      throw RangeError(
        "Given value is out of range. Set less than 2^31 - 1 value",
      );
    }
    return StartHeight._internal(value);
  }

  Uint8List serialize() => int32leBytes(value);
}
