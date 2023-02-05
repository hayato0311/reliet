import 'dart:typed_data';

import '../../extensions/int_extensions.dart';

class StartHeight {
  factory StartHeight(int value) {
    if (value > 0x7fffffff) {
      throw RangeError(
        'Given value is out of range. Set less than 0x7fffffff',
      );
    }
    return StartHeight._internal(value);
  }

  factory StartHeight.deserialize(Uint8List bytes) =>
      StartHeight(CreateInt.fromInt32leBytes(bytes));

  StartHeight._internal(this.value);

  static int bytesLength() => 4;

  final int value;

  Map<String, dynamic> toJson() => {'value': value};

  Uint8List serialize() => value.toInt32leBytes();
}
