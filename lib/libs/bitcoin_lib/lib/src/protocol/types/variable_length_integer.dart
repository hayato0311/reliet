import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../extensions/int_extensions.dart';

@immutable
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
    final int value;
    if (headByte < 0xfd) {
      value = CreateInt.fromUint8Bytes(bytes.sublist(0, 1));
    } else if (headByte == 0xfd) {
      value = CreateInt.fromUint16leBytes(bytes.sublist(1, 3));
    } else if (headByte == 0xfe) {
      value = CreateInt.fromUint32leBytes(bytes.sublist(1, 5));
    } else if (headByte == 0xff) {
      value = CreateInt.fromUint64leBytes(bytes.sublist(1, 9));
    } else {
      throw ArgumentError('The head byte of given bytes is invalid');
    }

    return VarInt(value);
  }

  late final int length;
  late final int headByte;
  late final int value;

  int bytesLength() {
    if (headByte < 0xfd) {
      return 1;
    } else if (headByte == 0xfd) {
      return 3;
    } else if (headByte == 0xfe) {
      return 5;
    } else if (headByte == 0xff) {
      return 9;
    }

    throw ArgumentError('The given head byte is not a byte value');
  }

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
