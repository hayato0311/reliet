import 'dart:convert';
import "dart:typed_data";

// of 1 byte

Uint8List int8Bytes(int value) =>
    Uint8List(1)..buffer.asByteData().setInt8(0, value);

Uint8List uint8Bytes(int value) =>
    Uint8List(1)..buffer.asByteData().setUint8(0, value);

// int big endian

Uint8List int16beBytes(int value) =>
    Uint8List(2)..buffer.asByteData().setInt16(0, value, Endian.big);

Uint8List int32beBytes(int value) =>
    Uint8List(4)..buffer.asByteData().setInt32(0, value, Endian.big);

Uint8List int64beBytes(int value) =>
    Uint8List(8)..buffer.asByteData().setInt64(0, value, Endian.big);

// uint big endian

Uint8List uint16beBytes(int value) =>
    Uint8List(2)..buffer.asByteData().setUint16(0, value, Endian.big);

Uint8List uint32beBytes(int value) =>
    Uint8List(4)..buffer.asByteData().setUint32(0, value, Endian.big);

Uint8List uint64beBytes(int value) =>
    Uint8List(8)..buffer.asByteData().setUint64(0, value, Endian.big);

// int little endian

Uint8List int16leBytes(int value) =>
    Uint8List(2)..buffer.asByteData().setInt16(0, value, Endian.little);

Uint8List int32leBytes(int value) =>
    Uint8List(4)..buffer.asByteData().setInt32(0, value, Endian.little);

Uint8List int64leBytes(int value) =>
    Uint8List(8)..buffer.asByteData().setInt64(0, value, Endian.little);

// uint little endian

Uint8List uint16leBytes(int value) =>
    Uint8List(2)..buffer.asByteData().setUint16(0, value, Endian.little);

Uint8List uint32leBytes(int value) =>
    Uint8List(4)..buffer.asByteData().setUint32(0, value, Endian.little);

Uint8List uint64leBytes(int value) =>
    Uint8List(8)..buffer.asByteData().setUint64(0, value, Endian.little);

// string

Uint8List stringBytes(String string, int length) {
  final List<int> byteList = List.from(utf8.encode(string));
  if (byteList.length > length) {
    throw ArgumentError("The string is longer than given length");
  }
  if (byteList.length < length) {
    byteList.insertAll(
        byteList.length, List.generate(length - byteList.length, (i) => 0));
  }
  return Uint8List.fromList(byteList);
}

// boolean

int boolToint(bool value) => value ? 1 : 0;
