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
    const noiseBytes = [1, 1, 1];
    test('which value is less than 0xfd', () {
      const varIntValue = 0xfc;
      final serializedVarIntBytes = VarInt(varIntValue).serialize();

      expect(
        VarInt.deserialize(
          Uint8List.fromList([...serializedVarIntBytes, ...noiseBytes]),
        ).value,
        varIntValue,
      );
    });
    test('which value is less than 0x10000', () {
      const varIntValue = 0xfffd;
      final serializedVarIntBytes = VarInt(varIntValue).serialize();

      expect(
        VarInt.deserialize(
          Uint8List.fromList([...serializedVarIntBytes, ...noiseBytes]),
        ).value,
        varIntValue,
      );
    });
    test('which value is less than 0x100000000', () {
      const varIntValue = 0xfffffffd;
      final serializedVarIntBytes = VarInt(varIntValue).serialize();

      expect(
        VarInt.deserialize(
          Uint8List.fromList([...serializedVarIntBytes, ...noiseBytes]),
        ).value,
        varIntValue,
      );
    });
    test('which value is 0x100000000 or more', () {
      const varIntValue = 0x7fffffffffffffff;
      final serializedVarIntBytes = VarInt(varIntValue).serialize();

      expect(
        VarInt.deserialize(
          Uint8List.fromList([...serializedVarIntBytes, ...noiseBytes]),
        ).value,
        varIntValue,
      );
    });
  });

  group('get length of bytes', () {
    test('which value is less than 0xfd', () {
      final varInt = VarInt(0xfc);
      expect(varInt.bytesLength(), 1);
    });
    test('which value is less than 0x10000', () {
      final varInt = VarInt(0xffff);
      expect(varInt.bytesLength(), 3);
    });
    test('which value is less than 0x100000000', () {
      final varInt = VarInt(0xffffffff);
      expect(varInt.bytesLength(), 5);
    });
    test('which value is 0x100000000 or more', () {
      final varInt = VarInt(0x7ffffffff);
      expect(varInt.bytesLength(), 9);
    });
  });
}
