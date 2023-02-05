import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_integer.dart';

void main() {
  group('create and serialize VarInt instance', () {
    test('which value is less than 0xfd', () {
      const varIntValue = 0xfc;
      final varInt = VarInt(varIntValue);

      expect(varInt.length, 1);
      expect(varInt.headByte, 0);
      expect(varInt.serialize(), varIntValue.toUint8Bytes());
    });
    test('which value is less than 0x10000', () {
      const varIntValue = 0xfffd;
      final varInt = VarInt(varIntValue);

      expect(varInt.length, 3);
      expect(varInt.headByte, 0xfd);
      expect(
        varInt.serialize(),
        Uint8List.fromList([0xfd, ...varIntValue.toUint16leBytes()]),
      );
    });

    test('which value is less than 0x100000000', () {
      const varIntValue = 0xfffffffd;
      final varInt = VarInt(varIntValue);

      expect(varInt.length, 5);
      expect(varInt.headByte, 0xfe);
      expect(
        varInt.serialize(),
        Uint8List.fromList([0xfe, ...varIntValue.toUint32leBytes()]),
      );
    });

    test('which value is 0x100000000 or more', () {
      const varIntValue = 0x7fffffffffffffff;
      final varInt = VarInt(varIntValue);

      expect(varInt.length, 9);
      expect(varInt.headByte, 0xff);
      expect(
        varInt.serialize(),
        Uint8List.fromList([0xff, ...varIntValue.toUint64leBytes()]),
      );
    });
  });

  group('deserialize bytes to VarInt instance', () {
    test('which value is less than 0xfd', () {
      const varIntValue = 0xfc;
      final serializedVarIntBytes = VarInt(varIntValue).serialize();
      print(serializedVarIntBytes);

      expect(VarInt.deserialize(serializedVarIntBytes).value, varIntValue);
    });
    test('which value is less than 0x10000', () {
      const varIntValue = 0xfffd;
      final serializedVarIntBytes = VarInt(varIntValue).serialize();

      expect(VarInt.deserialize(serializedVarIntBytes).value, varIntValue);
    });
    test('which value is less than 0x100000000', () {
      const varIntValue = 0xfffffffd;
      final serializedVarIntBytes = VarInt(varIntValue).serialize();

      expect(VarInt.deserialize(serializedVarIntBytes).value, varIntValue);
    });
    test('which value is 0x100000000 or more', () {
      const varIntValue = 0x7fffffffffffffff;
      final serializedVarIntBytes = VarInt(varIntValue).serialize();

      expect(VarInt.deserialize(serializedVarIntBytes).value, varIntValue);
    });

    test('with invalid bytes', () {
      expect(
        () => VarInt.deserialize(Uint8List.fromList([0, 0, 0, 1])),
        throwsArgumentError,
      );
    });
  });

  group('get bytes of length based on the head byte', () {
    test('which value is 0xfd', () {
      const headByte = 0xfd;

      expect(VarInt.bytesLength(headByte), 3);
    });
    test('which value is 0xfe', () {
      const headByte = 0xfe;

      expect(VarInt.bytesLength(headByte), 5);
    });
    test('which value is 0xff', () {
      const headByte = 0xff;

      expect(VarInt.bytesLength(headByte), 9);
    });
    test('which value is other than 0xfd, 0xfe and 0xff', () {
      const headByte = 0xfc;

      expect(VarInt.bytesLength(headByte), 1);
    });

    test('with invalid bytes', () {
      const headByte = 0xff00;

      expect(() => VarInt.bytesLength(headByte), throwsArgumentError);
    });
  });
}
