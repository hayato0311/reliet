import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_integer.dart';

void main() {
  group('create and serialize VarInt instance', () {
    test('which value is less than 0xfd', () {
      final varInt = VarInt(0xfc);

      expect(varInt.length, 1);
      expect(varInt.headByte, 0);
      expect(varInt.serialize(), [0xfc]);
    });
    test('which value is less than 0x10000', () {
      final varInt = VarInt(0xfffd);

      expect(varInt.length, 3);
      expect(varInt.headByte, 0xfd);
      expect(varInt.serialize(), [0xfd, 0xfd, 0xff]);
    });

    test('which value is less than 0x100000000', () {
      final varInt = VarInt(0xfffffffd);

      expect(varInt.length, 5);
      expect(varInt.headByte, 0xfe);
      expect(varInt.serialize(), [0xfe, 0xfd, 0xff, 0xff, 0xff]);
    });

    test('which value is 0x100000000 or more', () {
      final varInt = VarInt(0x100000000);

      expect(varInt.length, 9);
      expect(varInt.headByte, 0xff);
      expect(
        varInt.serialize(),
        [0xff, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00],
      );
    });
    test('with max value', () {
      // the max value of integer in dart seems to be 0x7fffffffffffffff
      // ref: https://github.com/dart-lang/sdk/issues/41717

      final varInt = VarInt(0x7fffffffffffffff);

      expect(varInt.length, 9);
      expect(varInt.headByte, 0xff);
      expect(
        varInt.serialize(),
        [0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x7f],
      );
    });
  });
}
