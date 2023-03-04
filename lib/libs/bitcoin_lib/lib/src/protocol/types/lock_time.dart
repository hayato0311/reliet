import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../extensions/int_extensions.dart';
import 'lock_time_type.dart';

@immutable
class LockTime {
  factory LockTime(int value) {
    if (value < 0) {
      throw RangeError('LockTime value must be 0 or more');
    } else if (value == 0) {
      return LockTime._internal(LockTimeType.notLocked, value);
    } else if (value < 500000000) {
      return LockTime._internal(LockTimeType.blockNumber, value);
    } else {
      return LockTime._internal(LockTimeType.secondsUnixtime, value);
    }
  }
  const LockTime._internal(this.type, this.value);

  factory LockTime.deserialize(Uint8List bytes) =>
      LockTime(CreateInt.fromUint32leBytes(bytes));

  static int bytesLength() => 4;

  final LockTimeType type;
  final int value;

  Map<String, dynamic> toJson() => {'locktime': '${type.toString()}($value)'};

  Uint8List serialize() => value.toUint32leBytes();
}
