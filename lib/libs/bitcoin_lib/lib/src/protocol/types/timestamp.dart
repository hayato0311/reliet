import 'dart:typed_data';

import '../../encode.dart';

class Timestamp {
  final int value;

  Timestamp(this.value);

  Uint8List serialize() => int64leBytes(value);
}
