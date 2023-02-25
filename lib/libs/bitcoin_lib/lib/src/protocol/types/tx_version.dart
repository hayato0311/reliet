import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../extensions/int_extensions.dart';

@immutable
class TxVersion {
  factory TxVersion(int value) {
    if (value > 2) {
      throw RangeError(
        'Given value is out of range. Set less than 2',
      );
    }
    return TxVersion._internal(value);
  }

  factory TxVersion.deserialize(Uint8List bytes) =>
      TxVersion(CreateInt.fromUint32leBytes(bytes));

  const TxVersion._internal(this.value);

  static int bytesLength() => 4;

  final int value;

  Map<String, dynamic> toJson() => {'value': value};

  Uint8List serialize() => value.toUint32leBytes();
}
