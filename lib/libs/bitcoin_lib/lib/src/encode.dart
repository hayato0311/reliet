import 'dart:convert';
import "dart:typed_data";

import 'hash.dart';

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

// char big endian

Uint8List stringbeBytes(String string, int length) {
  final List<int> byteList = List.from(utf8.encode(string));
  if (byteList.length > length) {
    throw Exception("");
  }
  if (byteList.length < length) {
    byteList.insertAll(0, List.generate(length - byteList.length, (i) => 0));
  }
  return Uint8List.fromList(byteList);
}

// char little endian

// Uint8List charleBytes(String input) => Uint8List.fromList(utf8.encode(input));

Uint8List stringleBytes(String string, int length) {
  final List<int> byteList = List.from(stringbeBytes(string, length).reversed);
  return Uint8List.fromList(byteList);
}

int boolToint(bool value) => value ? 1 : 0;

// checksum

List<int> payloadToChecksum(Uint8List payload) =>
    utf8.encode(hash256(payload).toString()).sublist(0, 4);
