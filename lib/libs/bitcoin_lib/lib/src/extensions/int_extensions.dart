import 'dart:typed_data';

extension IntExtensions on int {
  // of 1 byte
  Uint8List toInt8Bytes() => Uint8List(1)..buffer.asByteData().setInt8(0, this);

  Uint8List toUint8Bytes() =>
      Uint8List(1)..buffer.asByteData().setUint8(0, this);

  // int big endian
  Uint8List toInt16beBytes() =>
      Uint8List(2)..buffer.asByteData().setInt16(0, this);

  Uint8List toInt32beBytes() =>
      Uint8List(4)..buffer.asByteData().setInt32(0, this);

  Uint8List toInt64beBytes() =>
      Uint8List(8)..buffer.asByteData().setInt64(0, this);

  // uint big endian
  Uint8List toUint16beBytes() =>
      Uint8List(2)..buffer.asByteData().setUint16(0, this);

  Uint8List toUint32beBytes() =>
      Uint8List(4)..buffer.asByteData().setUint32(0, this);

  Uint8List toUint64beBytes() =>
      Uint8List(8)..buffer.asByteData().setUint64(0, this);

  // int little endian
  Uint8List toInt16leBytes() =>
      Uint8List(2)..buffer.asByteData().setInt16(0, this, Endian.little);

  Uint8List toInt32leBytes() =>
      Uint8List(4)..buffer.asByteData().setInt32(0, this, Endian.little);

  Uint8List toInt64leBytes() =>
      Uint8List(8)..buffer.asByteData().setInt64(0, this, Endian.little);

  // uint little endian
  Uint8List toUint16leBytes() =>
      Uint8List(2)..buffer.asByteData().setUint16(0, this, Endian.little);

  Uint8List toUint32leBytes() =>
      Uint8List(4)..buffer.asByteData().setUint32(0, this, Endian.little);

  Uint8List toUint64leBytes() =>
      Uint8List(8)..buffer.asByteData().setUint64(0, this, Endian.little);
}
