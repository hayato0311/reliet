import 'dart:typed_data';

import '../../utils/encode.dart';

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
      byteList = int8Bytes(value);
    } else if (headByte == 0xfd) {
      byteList += [headByte];
      byteList += int16leBytes(value);
    } else if (headByte == 0xfe) {
      byteList += [headByte];
      byteList += int32leBytes(value);
    } else {
      byteList += [headByte];
      byteList += int64leBytes(value);
    }

    return Uint8List.fromList(byteList);
  }
}
