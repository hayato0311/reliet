import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';

void main() {
  group('convert integer into bytes', () {
    const value = 10;
    test('of 1 byte', () {
      expect(value.toInt8Bytes(), Uint8List.fromList([10]));
      expect(value.toUint8Bytes(), Uint8List.fromList([10]));
    });
    group('as big endian', () {
      test('of int', () {
        expect(value.toInt16beBytes(), Uint8List.fromList([0, 10]));
        expect(value.toInt32beBytes(), Uint8List.fromList([0, 0, 0, 10]));
        expect(
          value.toInt64beBytes(),
          Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 10]),
        );
      });
      test('of uint', () {
        expect(value.toUint16beBytes(), Uint8List.fromList([0, 10]));
        expect(value.toUint32beBytes(), Uint8List.fromList([0, 0, 0, 10]));
        expect(
          value.toUint64beBytes(),
          Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 10]),
        );
      });
    });
    group('as little endian', () {
      test('of int', () {
        expect(value.toInt16leBytes(), Uint8List.fromList([10, 0]));
        expect(value.toInt32leBytes(), Uint8List.fromList([10, 0, 0, 0]));
        expect(
          value.toInt64leBytes(),
          Uint8List.fromList([10, 0, 0, 0, 0, 0, 0, 0]),
        );
      });
      test('of uint', () {
        expect(value.toUint16leBytes(), Uint8List.fromList([10, 0]));
        expect(value.toUint32leBytes(), Uint8List.fromList([10, 0, 0, 0]));
        expect(
          value.toUint64leBytes(),
          Uint8List.fromList([10, 0, 0, 0, 0, 0, 0, 0]),
        );
      });
    });
  });
}
