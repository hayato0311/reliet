import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';

void main() {
  group('convert integer into bytes', () {
    const value = 10;
    test('of 1 byte', () {
      final invalidValue = pow(2, 8) as int;

      expect(value.toInt8Bytes(), Uint8List.fromList([10]));
      expect(value.toUint8Bytes(), Uint8List.fromList([10]));

      expect(invalidValue.toInt8Bytes, throwsRangeError);
      expect(invalidValue.toUint8Bytes, throwsRangeError);
    });
    group('as big endian', () {
      test('of int', () {
        final invalidValue1 = pow(2, 16) as int;
        final invalidValue2 = pow(2, 32) as int;

        expect(value.toInt16beBytes(), Uint8List.fromList([0, 10]));
        expect(value.toInt32beBytes(), Uint8List.fromList([0, 0, 0, 10]));
        expect(
          value.toInt64beBytes(),
          Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 10]),
        );

        expect(invalidValue1.toInt16beBytes, throwsRangeError);
        expect(invalidValue2.toInt32beBytes, throwsRangeError);
      });
      test('of uint', () {
        final invalidValue1 = pow(2, 16) as int;
        final invalidValue2 = pow(2, 32) as int;

        expect(value.toUint16beBytes(), Uint8List.fromList([0, 10]));
        expect(value.toUint32beBytes(), Uint8List.fromList([0, 0, 0, 10]));
        expect(
          value.toUint64beBytes(),
          Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 10]),
        );

        expect(invalidValue1.toInt16beBytes, throwsRangeError);
        expect(invalidValue2.toInt32beBytes, throwsRangeError);
      });
    });
    group('as little endian', () {
      test('of int', () {
        final invalidValue1 = pow(2, 16) as int;
        final invalidValue2 = pow(2, 32) as int;

        expect(value.toInt16leBytes(), Uint8List.fromList([10, 0]));
        expect(value.toInt32leBytes(), Uint8List.fromList([10, 0, 0, 0]));
        expect(
          value.toInt64leBytes(),
          Uint8List.fromList([10, 0, 0, 0, 0, 0, 0, 0]),
        );

        expect(invalidValue1.toInt16beBytes, throwsRangeError);
        expect(invalidValue2.toInt32beBytes, throwsRangeError);
      });
      test('of uint', () {
        final invalidValue1 = pow(2, 16) as int;
        final invalidValue2 = pow(2, 32) as int;

        expect(value.toUint16leBytes(), Uint8List.fromList([10, 0]));
        expect(value.toUint32leBytes(), Uint8List.fromList([10, 0, 0, 0]));
        expect(
          value.toUint64leBytes(),
          Uint8List.fromList([10, 0, 0, 0, 0, 0, 0, 0]),
        );

        expect(invalidValue1.toInt16beBytes, throwsRangeError);
        expect(invalidValue2.toInt32beBytes, throwsRangeError);
      });
    });
  });

  group('convert bytes into int', () {
    test('of 1 byte', () {
      final bytes1 = Uint8List.fromList([10]);
      final bytes2 = Uint8List.fromList([10, 10]);
      expect(CreateInt.fromInt8Bytes(bytes1), 10);
      expect(CreateInt.fromUint8Bytes(bytes1), 10);

      expect(() => CreateInt.fromInt8Bytes(bytes2), throwsArgumentError);
      expect(() => CreateInt.fromUint8Bytes(bytes2), throwsArgumentError);
    });
    test('of 2 bytes', () {
      final bytes1 = Uint8List.fromList([0, 128]);
      final bytes2 = Uint8List.fromList([128, 0]);
      final bytes3 = Uint8List.fromList([128, 0, 0, 0]);

      expect(CreateInt.fromInt16beBytes(bytes1), 128);
      expect(CreateInt.fromUint16beBytes(bytes1), 128);
      expect(CreateInt.fromInt16leBytes(bytes1), -32768);
      expect(CreateInt.fromUint16leBytes(bytes1), 32768);

      expect(CreateInt.fromInt16beBytes(bytes2), -32768);
      expect(CreateInt.fromUint16beBytes(bytes2), 32768);
      expect(CreateInt.fromInt16leBytes(bytes2), 128);
      expect(CreateInt.fromUint16leBytes(bytes2), 128);

      expect(() => CreateInt.fromInt16beBytes(bytes3), throwsArgumentError);
      expect(() => CreateInt.fromUint16beBytes(bytes3), throwsArgumentError);
      expect(() => CreateInt.fromInt16leBytes(bytes3), throwsArgumentError);
      expect(() => CreateInt.fromUint16leBytes(bytes3), throwsArgumentError);
    });
    test('of 4 bytes', () {
      final bytes1 = Uint8List.fromList([0, 0, 0, 128]);
      final bytes2 = Uint8List.fromList([128, 0, 0, 0]);
      final bytes3 = Uint8List.fromList([128, 0, 0, 0, 0, 0]);

      expect(CreateInt.fromInt32beBytes(bytes1), 128);
      expect(CreateInt.fromUint32beBytes(bytes1), 128);
      expect(CreateInt.fromInt32leBytes(bytes1), -2147483648);
      expect(CreateInt.fromUint32leBytes(bytes1), 2147483648);

      expect(CreateInt.fromInt32beBytes(bytes2), -2147483648);
      expect(CreateInt.fromUint32beBytes(bytes2), 2147483648);
      expect(CreateInt.fromInt32leBytes(bytes2), 128);
      expect(CreateInt.fromUint32leBytes(bytes2), 128);

      expect(() => CreateInt.fromInt32beBytes(bytes3), throwsArgumentError);
      expect(() => CreateInt.fromUint32beBytes(bytes3), throwsArgumentError);
      expect(() => CreateInt.fromInt32leBytes(bytes3), throwsArgumentError);
      expect(() => CreateInt.fromUint32leBytes(bytes3), throwsArgumentError);
    });

    test('of 8 bytes', () {
      final bytes1 = Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 128]);
      final bytes2 = Uint8List.fromList([128, 0, 0, 0, 0, 0, 0, 0]);
      final bytes3 = Uint8List.fromList([1, 0, 0, 0]);

      expect(CreateInt.fromInt64beBytes(bytes1), 128);
      expect(CreateInt.fromInt64leBytes(bytes1), -9223372036854775808);

      expect(CreateInt.fromInt64beBytes(bytes2), -9223372036854775808);
      expect(CreateInt.fromInt64leBytes(bytes2), 128);

      expect(() => CreateInt.fromInt64beBytes(bytes3), throwsArgumentError);
      expect(() => CreateInt.fromInt64leBytes(bytes3), throwsArgumentError);
    });
  });
}
