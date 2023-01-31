import 'dart:typed_data';

import '../../extensions/int_extensions.dart';

class VarInt {
  VarInt(this.value) {
    if (value < 0xfd) {
      length = 1;
      headByte = 0;
    } else if (value < 0x10000) {
      length = 3;
      headByte = 0xfd;
    } else if (value < 0x100000000) {
      length = 5;
      headByte = 0xfe;
    } else {
      length = 9;
      headByte = 0xff;
    }
  }
  late final int length;
  late final int headByte;
  late final int value;

  Uint8List serialize() {
    var byteList = <int>[];
    if (headByte == 0) {
      byteList = value.toInt8Bytes();
    } else if (headByte == 0xfd) {
      byteList += [headByte];
      byteList += value.toInt16leBytes();
    } else if (headByte == 0xfe) {
      byteList += [headByte];
      byteList += value.toInt32leBytes();
    } else {
      byteList += [headByte];
      byteList += value.toInt64leBytes();
    }

    return Uint8List.fromList(byteList);
  }
}
