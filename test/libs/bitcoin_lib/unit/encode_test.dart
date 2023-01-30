import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/utils/encode.dart';

void main() {
  group('convert integer into bytes', () {
    test('of 1 byte', () {
      expect(int8Bytes(10), Uint8List.fromList([10]));
      expect(uint8Bytes(10), Uint8List.fromList([10]));
    });
    group('as big endian', () {
      test('of int', () {
        expect(int16beBytes(10), Uint8List.fromList([0, 10]));
        expect(int32beBytes(10), Uint8List.fromList([0, 0, 0, 10]));
        expect(int64beBytes(10), Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 10]));
      });
      test('of uint', () {
        expect(uint16beBytes(10), Uint8List.fromList([0, 10]));
        expect(uint32beBytes(10), Uint8List.fromList([0, 0, 0, 10]));
        expect(
          uint64beBytes(10),
          Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 10]),
        );
      });
    });
    group('as little endian', () {
      test('of int', () {
        expect(int16leBytes(10), Uint8List.fromList([10, 0]));
        expect(int32leBytes(10), Uint8List.fromList([10, 0, 0, 0]));
        expect(int64leBytes(10), Uint8List.fromList([10, 0, 0, 0, 0, 0, 0, 0]));
      });
      test('of uint', () {
        expect(uint16leBytes(10), Uint8List.fromList([10, 0]));
        expect(uint32leBytes(10), Uint8List.fromList([10, 0, 0, 0]));
        expect(
          uint64leBytes(10),
          Uint8List.fromList([10, 0, 0, 0, 0, 0, 0, 0]),
        );
      });
    });
  });

  group('convert string into bytes', () {
    test('with valid length', () {
      expect(() => stringBytes('invalid', 1), throwsArgumentError);
    });
    test('with invalid length', () {
      expect(stringBytes('a', 2), [...utf8.encode('a'), 0]);
    });
  });
}
