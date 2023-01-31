import 'dart:typed_data';

import '../../extensions/int_extensions.dart';

class Timestamp {
  Timestamp(this.unixtime);
  final int unixtime;

  Uint8List serialize() => unixtime.toInt64leBytes();
}
