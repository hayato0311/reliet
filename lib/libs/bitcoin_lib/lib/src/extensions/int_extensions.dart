import 'dart:math';
import 'dart:typed_data';

extension IntExtensions on int {
  // of 1 byte
  Uint8List toInt8Bytes() {
    if (this >= pow(2, 7)) {
      throw RangeError('the value must be less than ${pow(2, 7)}(2^7)');
    }
    if (this < -pow(2, 7)) {
      throw RangeError('the value must be ${-pow(2, 7)}(- 2^7) or more');
    }

    return Uint8List(1)..buffer.asByteData().setInt8(0, this);
  }

  Uint8List toUint8Bytes() {
    if (this >= pow(2, 8)) {
      throw RangeError('the value must be less than ${pow(2, 8)}(2^8)');
    }
    if (this < 0) {
      throw RangeError('the value must be 0 or more');
    }

    return Uint8List(1)..buffer.asByteData().setUint8(0, this);
  }

  // int big endian
  Uint8List toInt16beBytes() {
    if (this >= pow(2, 15)) {
      throw RangeError('the value must be less than ${pow(2, 15)}(2^15)');
    }
    if (this < -pow(2, 15)) {
      throw RangeError('the value must be ${-pow(2, 15)}(- 2^15) or more');
    }

    return Uint8List(2)..buffer.asByteData().setInt16(0, this);
  }

  Uint8List toInt32beBytes() {
    if (this >= pow(2, 31)) {
      throw RangeError('the value must be less than ${pow(2, 31)}(2^31)');
    }
    if (this < -pow(2, 31)) {
      throw RangeError('the value must be ${-pow(2, 31)}(- 2^31) or more');
    }

    return Uint8List(4)..buffer.asByteData().setInt32(0, this);
  }

  Uint8List toInt64beBytes() {
    return Uint8List(8)..buffer.asByteData().setInt64(0, this);
  }

  // uint big endian
  Uint8List toUint16beBytes() {
    if (this >= pow(2, 16)) {
      throw RangeError('the value must be less than ${pow(2, 16)}(2^16)');
    }
    if (this < 0) {
      throw RangeError('the value must be 0 or more');
    }

    return Uint8List(2)..buffer.asByteData().setUint16(0, this);
  }

  Uint8List toUint32beBytes() {
    if (this >= pow(2, 32)) {
      throw RangeError('the value must be less than ${pow(2, 32)}(2^32)');
    }
    if (this < 0) {
      throw RangeError('the value must be 0 or more');
    }

    return Uint8List(4)..buffer.asByteData().setUint32(0, this);
  }

  Uint8List toUint64beBytes() {
    if (this < 0) {
      throw RangeError('the value must be 0 or more');
    }

    return Uint8List(8)..buffer.asByteData().setUint64(0, this);
  }

  // int little endian
  Uint8List toInt16leBytes() {
    if (this >= pow(2, 15)) {
      throw RangeError('the value must be less than ${pow(2, 15)}(2^15)');
    }
    if (this < -pow(2, 15)) {
      throw RangeError('the value must be ${-pow(2, 15)}(- 2^15) or more');
    }

    return Uint8List(2)..buffer.asByteData().setInt16(0, this, Endian.little);
  }

  Uint8List toInt32leBytes() {
    if (this >= pow(2, 31)) {
      throw RangeError('the value must be less than ${pow(2, 31)}(2^31)');
    }
    if (this < -pow(2, 31)) {
      throw RangeError('the value must be ${-pow(2, 31)}(- 2^31) or more');
    }

    return Uint8List(4)..buffer.asByteData().setInt32(0, this, Endian.little);
  }

  Uint8List toInt64leBytes() {
    return Uint8List(8)..buffer.asByteData().setInt64(0, this, Endian.little);
  }

  // uint little endian
  Uint8List toUint16leBytes() {
    if (this >= pow(2, 16)) {
      throw RangeError('the value must be less than ${pow(2, 16)}(2^16)');
    }
    if (this < 0) {
      throw RangeError('the value must be 0 or more');
    }

    return Uint8List(2)..buffer.asByteData().setUint16(0, this, Endian.little);
  }

  Uint8List toUint32leBytes() {
    if (this >= pow(2, 32)) {
      throw RangeError('the value must be less than ${pow(2, 32)}(2^32)');
    }
    if (this < 0) {
      throw RangeError('the value must be 0 or more');
    }

    return Uint8List(4)..buffer.asByteData().setUint32(0, this, Endian.little);
  }

  Uint8List toUint64leBytes() {
    if (this < 0) {
      throw RangeError('the value must be 0 or more');
    }

    return Uint8List(8)..buffer.asByteData().setUint64(0, this, Endian.little);
  }
}

extension CreateInt on int {
  // of 1 byte
  static int fromInt8Bytes(Uint8List bytes) {
    if (bytes.length != 1) {
      throw ArgumentError('the length of bytes must be 1');
    }

    return bytes.buffer.asByteData().getInt8(0);
  }

  static int fromUint8Bytes(Uint8List bytes) {
    if (bytes.length != 1) {
      throw ArgumentError('the length of bytes must be 1');
    }

    return bytes.buffer.asByteData().getUint8(0);
  }

  // int big endian
  static int fromInt16beBytes(Uint8List bytes) {
    if (bytes.length != 2) {
      throw ArgumentError('the length of bytes must be 2');
    }

    return bytes.buffer.asByteData().getInt16(0);
  }

  static int fromInt32beBytes(Uint8List bytes) {
    if (bytes.length != 4) {
      throw ArgumentError('the length of bytes must be 4');
    }

    return bytes.buffer.asByteData().getInt32(0);
  }

  static int fromInt64beBytes(Uint8List bytes) {
    if (bytes.length != 8) {
      throw ArgumentError('the length of bytes must be 8');
    }

    return bytes.buffer.asByteData().getInt64(0);
  }

  // uint big endian
  static int fromUint16beBytes(Uint8List bytes) {
    if (bytes.length != 2) {
      throw ArgumentError('the length of bytes must be 2');
    }

    return bytes.buffer.asByteData().getUint16(0);
  }

  static int fromUint32beBytes(Uint8List bytes) {
    if (bytes.length != 4) {
      throw ArgumentError('the length of bytes must be 4');
    }

    return bytes.buffer.asByteData().getUint32(0);
  }

  // int little endian
  static int fromInt16leBytes(Uint8List bytes) {
    if (bytes.length != 2) {
      throw ArgumentError('the length of bytes must be 2');
    }

    return bytes.buffer.asByteData().getInt16(0, Endian.little);
  }

  static int fromInt32leBytes(Uint8List bytes) {
    if (bytes.length != 4) {
      throw ArgumentError('the length of bytes must be 4');
    }

    return bytes.buffer.asByteData().getInt32(0, Endian.little);
  }

  static int fromInt64leBytes(Uint8List bytes) {
    if (bytes.length != 8) {
      throw ArgumentError('the length of bytes must be 8');
    }

    return bytes.buffer.asByteData().getInt64(0, Endian.little);
  }

  // uint little endian
  static int fromUint16leBytes(Uint8List bytes) {
    if (bytes.length != 2) {
      throw ArgumentError('the length of bytes must be 2');
    }

    return bytes.buffer.asByteData().getUint16(0, Endian.little);
  }

  static int fromUint32leBytes(Uint8List bytes) {
    if (bytes.length != 4) {
      throw ArgumentError('the length of bytes must be 4');
    }

    return bytes.buffer.asByteData().getUint32(0, Endian.little);
  }
}
