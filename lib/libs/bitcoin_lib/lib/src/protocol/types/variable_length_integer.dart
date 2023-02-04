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

  factory VarInt.deserialize(Uint8List bytes) {
    final headByte = bytes[0];
    late final int value;
    if (bytes.length == 1) {
      value = CreateInt.fromUint8Bytes(bytes);
    } else if (headByte == 0xfd) {
      value = CreateInt.fromUint16leBytes(bytes.sublist(1));
    } else if (headByte == 0xfe) {
      value = CreateInt.fromUint32leBytes(bytes.sublist(1));
    } else if (headByte == 0xff) {
      value = CreateInt.fromUint64leBytes(bytes.sublist(1));
    } else {
      throw ArgumentError('The head byte of given bytes is invalid');
    }

    return VarInt(value);
  }

  static int bytesLength(int headByte) {
    if (headByte == 0xfd) {
      return 3;
    } else if (headByte == 0xfe) {
      return 5;
    } else if (headByte == 0xff) {
      return 9;
    } else if (headByte > 0xff) {
      throw ArgumentError('The given head byte is not a byte value');
    } else {
      return 1;
    }
  }

  late final int length;
  late final int headByte;
  late final int value;

  Map<String, dynamic> toJson() =>
      {'length': length, 'headByte': headByte, 'value': value};

  Uint8List serialize() {
    var byteList = <int>[];
    if (headByte == 0) {
      byteList = value.toUint8Bytes();
    } else if (headByte == 0xfd) {
      byteList += [headByte];
      byteList += value.toUint16leBytes();
    } else if (headByte == 0xfe) {
      byteList += [headByte];
      byteList += value.toUint32leBytes();
    } else {
      byteList += [headByte];
      byteList += value.toUint64leBytes();
    }

    return Uint8List.fromList(byteList);
  }
}
