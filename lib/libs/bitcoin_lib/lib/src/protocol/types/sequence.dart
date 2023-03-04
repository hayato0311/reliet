import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../extensions/int_extensions.dart';

@immutable
class Sequence {
  factory Sequence(int value) {
    if (value > 0xffffffff) {
      throw RangeError(
        'Given value is out of range. Set 0xffffffff or less value',
      );
    }
    return Sequence._internal(value);
  }

  factory Sequence.deserialize(Uint8List bytes) =>
      Sequence(CreateInt.fromUint32leBytes(bytes));

  const Sequence._internal(this.value);

  static int bytesLength() => 4;

  final int value;

  Map<String, dynamic> toJson() => {'value': value};

  Uint8List serialize() => value.toUint32leBytes();
}
