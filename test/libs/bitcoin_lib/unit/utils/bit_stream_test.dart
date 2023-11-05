import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/utils/bit_stream.dart';

void main() {
  group('read bits', () {
    test('with valid args', () {
      final bitStream = BitStream(BigInt.parse('1000111001', radix: 2));
      expect(
        bitStream.read(1),
        BigInt.parse('1', radix: 2),
      );
      expect(
        bitStream.read(2),
        BigInt.parse('00', radix: 2),
      );
      expect(
        bitStream.read(5),
        BigInt.parse('01110', radix: 2),
      );
      expect(
        bitStream.read(2),
        BigInt.parse('01', radix: 2),
      );
      // TODO: fix to raise exception
      expect(
        bitStream.read(1),
        BigInt.parse('0', radix: 2),
      );
    });
  });
  group('write bits', () {
    test('with valid args', () {
      final bitStream = BitStream(BigInt.parse('1'));

      bitStream.write(BigInt.parse('1'), 1);

      expect(
        bitStream.read(2),
        BigInt.parse('11', radix: 2),
      );

      expect(
        bitStream.value.bitLength,
        0,
      );

      bitStream.write(BigInt.parse('1001', radix: 2), 4);

      expect(
        bitStream.read(2),
        BigInt.parse('10', radix: 2),
      );

      expect(
        bitStream.read(2),
        BigInt.parse('01', radix: 2),
      );

      expect(
        bitStream.value.bitLength,
        0,
      );

      bitStream.write(BigInt.parse('10', radix: 2));
      bitStream.write(BigInt.parse('0', radix: 2));

      expect(
        bitStream.read(3),
        BigInt.parse('100', radix: 2),
      );

      expect(
        bitStream.value.bitLength,
        0,
      );
    });
  });
}
