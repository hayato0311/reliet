import 'dart:typed_data';

import '../../utils/encode.dart';

class Timestamp {
  final int unixtime;

  Timestamp(this.unixtime);

  Uint8List serialize() => int64leBytes(unixtime);
}
