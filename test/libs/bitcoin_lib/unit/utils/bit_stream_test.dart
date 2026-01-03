import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/utils/bit_stream.dart';

void main() {
  group('read bits', () {
    test('when reading bits sequentially from value', () {
      // 1000111001 (10 bits)
      final bitStream = BitStream(BigInt.parse('1000111001', radix: 2));

      expect(bitStream.read(1), BigInt.parse('1', radix: 2)); // 1
      expect(bitStream.read(2), BigInt.parse('00', radix: 2)); // 00
      expect(bitStream.read(5), BigInt.parse('01110', radix: 2)); // 01110
      expect(bitStream.read(2), BigInt.parse('01', radix: 2)); // 01

      // TODO: fix to raise exception
      expect(bitStream.read(1), BigInt.parse('0', radix: 2));
    });
  });

  group('write bits', () {
    test('when writing and reading bits', () {
      final bitStream = BitStream(BigInt.parse('1'));

      // Append 1 to 1 → 11
      bitStream.write(BigInt.parse('1'), 1);
      expect(bitStream.read(2), BigInt.parse('11', radix: 2));
      expect(bitStream.value.bitLength, 0);
    });

    test('with explicit numBits', () {
      final bitStream = BitStream(BigInt.zero);

      // Write 1001 as 4 bits
      bitStream.write(BigInt.parse('1001', radix: 2), 4);

      expect(bitStream.read(2), BigInt.parse('10', radix: 2));
      expect(bitStream.read(2), BigInt.parse('01', radix: 2));
      expect(bitStream.value.bitLength, 0);
    });

    test('with auto-detected numBits', () {
      final bitStream = BitStream(BigInt.zero);

      // Write 10 (auto-detect 2 bits)
      bitStream.write(BigInt.parse('10', radix: 2));
      // Write 0 (auto-detect 1 bit)
      bitStream.write(BigInt.parse('0', radix: 2));

      // Total 3 bits: 100
      expect(bitStream.read(3), BigInt.parse('100', radix: 2));
      expect(bitStream.value.bitLength, 0);
    });

    // Golomb-Rice x=1 encode scenario
    // x=1: q=0, r=1
    // Bit sequence: 0 (terminator) + 0000000000000000001 (r=1 in 19 bits) = 20 bits
    test('with Golomb-Rice encode x=1 scenario', () {
      final bitStream = BitStream(BigInt.zero);

      // terminator: write 0 as 1 bit
      bitStream.write(BigInt.zero, 1);
      expect(bitStream.value, BigInt.zero);
      expect(bitStream.numTopZeroBits, 1);

      // remainder: write 1 as 19 bits (0000000000000000001)
      bitStream.writeTailBits(BigInt.one, 19);
      expect(bitStream.value, BigInt.one);
      // Leading zero bits = 1 (first write) + 18 (leading zeros in 19 bits) = 19
      expect(bitStream.numTopZeroBits, 19);

      // Decode: read from the same BitStream
      final decodeStream = BitStream(bitStream.value);
      decodeStream.numTopZeroBits = bitStream.numTopZeroBits;

      // Read first 1 bit (terminator: 0)
      expect(decodeStream.read(1), BigInt.zero);

      // Read next 19 bits (r=1)
      expect(decodeStream.read(19), BigInt.one);
    });
  });
}
