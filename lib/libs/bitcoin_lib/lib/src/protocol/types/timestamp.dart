import 'dart:typed_data';

import '../../extensions/int_extensions.dart';

class Timestamp {
  Timestamp._internal(this.secondsUnixtime);

  factory Timestamp.create() {
    final secondsUnixtime =
        (DateTime.now().millisecondsSinceEpoch / 1000).floor();

    return Timestamp._internal(secondsUnixtime);
  }

  factory Timestamp.deserialize(Uint8List bytes) =>
      Timestamp._internal(CreateInt.fromInt64leBytes(bytes));

  final int secondsUnixtime;

  Uint8List serialize() => secondsUnixtime.toInt64leBytes();
}
