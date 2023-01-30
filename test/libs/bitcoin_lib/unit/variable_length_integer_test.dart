import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_integer.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/utils/encode.dart';

void main() {
  group('create and serialize VarInt instance', () {
    test('which value is less than 0xfd', () {
      const varIntValue = 0xfc;
      final varInt = VarInt(varIntValue);

      expect(varInt.length, 1);
      expect(varInt.headByte, 0);
      expect(varInt.serialize(), int8Bytes(varIntValue));
    });
    test('which value is less than 0x10000', () {
      const varIntValue = 0xfffd;
      final varInt = VarInt(varIntValue);

      expect(varInt.length, 3);
      expect(varInt.headByte, 0xfd);
      expect(
        varInt.serialize(),
        Uint8List.fromList([0xfd, ...int16leBytes(varIntValue)]),
      );
    });

    test('which value is less than 0x100000000', () {
      const varIntValue = 0xfffffffd;
      final varInt = VarInt(varIntValue);

      expect(varInt.length, 5);
      expect(varInt.headByte, 0xfe);
      expect(
        varInt.serialize(),
        Uint8List.fromList([0xfe, ...int32leBytes(varIntValue)]),
      );
    });

    test('which value is 0x100000000 or more', () {
      const varIntValue = 0x7fffffffffffffff;
      final varInt = VarInt(varIntValue);

      expect(varInt.length, 9);
      expect(varInt.headByte, 0xff);
      expect(
        varInt.serialize(),
        Uint8List.fromList([0xff, ...int64leBytes(varIntValue)]),
      );
    });
  });
}
