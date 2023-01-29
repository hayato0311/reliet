import 'dart:typed_data';

import '../../utils/encode.dart';

class Timestamp {
  Timestamp(this.unixtime);
  final int unixtime;

  Uint8List serialize() => int64leBytes(unixtime);
}
