import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../extensions/int_extensions.dart';

@immutable
class TxOutPointIndex {
  factory TxOutPointIndex(int value) {
    if (value > 0xffffffff) {
      throw RangeError(
        'Given value is out of range. Set 0xffffffff or less value',
      );
    }
    return TxOutPointIndex._internal(value);
  }

  factory TxOutPointIndex.deserialize(Uint8List bytes) =>
      TxOutPointIndex(CreateInt.fromUint32leBytes(bytes));

  const TxOutPointIndex._internal(this.value);

  static int bytesLength() => 4;

  final int value;

  Map<String, dynamic> toJson() => {'value': value};

  Uint8List serialize() => value.toUint32leBytes();
}
