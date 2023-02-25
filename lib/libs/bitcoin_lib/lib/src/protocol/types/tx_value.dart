import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../extensions/int_extensions.dart';

@immutable
class TxValue {
  factory TxValue(int value) {
    return TxValue._internal(value);
  }

  factory TxValue.deserialize(Uint8List bytes) =>
      TxValue(CreateInt.fromInt64leBytes(bytes));

  const TxValue._internal(this.value);

  static int bytesLength() => 8;

  final int value;

  Map<String, dynamic> toJson() => {'value': value};

  Uint8List serialize() => value.toInt64leBytes();
}
