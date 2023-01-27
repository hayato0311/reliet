import 'dart:typed_data';

import '../../encode.dart';

class VarInt {
  late final int length;
  late final int headByte;
  late final int value;

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

  Uint8List serialize() {
    List<int> byteList = [];
    if (headByte == 0) {
      byteList = int8Bytes(value).toList();
    } else if (headByte == 0xfd) {
      byteList += [headByte];
      byteList += int16leBytes(value).toList();
    } else if (headByte == 0xfe) {
      byteList += [headByte];
      byteList += int32leBytes(value).toList();
    } else {
      byteList += [headByte];
      byteList += int64leBytes(value).toList();
    }

    return Uint8List.fromList(byteList);
  }
}
