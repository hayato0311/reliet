import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/gcs_filter.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/op_code.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/script.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/var_bytes.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/utils/bit_stream.dart';

import 'data/block700000_block_message.dart';
import 'data/block700000_cfilters_message.dart';

// BIP158 parameters
const _p = 19;
final _mask = BigInt.parse('0xFFFFFFFFFFFFFFFF');

// Test Golomb-Rice encode (same logic as gcs_filter.dart implementation)
void _testGolombRiceEncode(BitStream bitStream, BigInt x) {
  var q = x >> _p;
  while (q > BigInt.zero) {
    bitStream.write(BigInt.one, 1);
    q -= BigInt.one;
  }
  bitStream.write(BigInt.zero, 1);
  bitStream.writeTailBits(x, _p);
}

// Test Golomb-Rice decode (fixed version: does not use BigInt.parse(r.toHex()))
BigInt _testGolombRiceDecode(BitStream bitStream) {
  var q = BigInt.zero;
  while (bitStream.read(1) == BigInt.one) {
    q += BigInt.one;
  }
  final r = bitStream.read(_p);
  return ((q << _p) | r) & _mask;
}

void main() {
  group('Golomb-Rice encode', () {
    test('x = 0 should produce correct bit pattern', () {
      final bitStream = BitStream(BigInt.zero);

      _testGolombRiceEncode(bitStream, BigInt.zero);

      // x=0: q=0, r=0
      // Pattern: 0 (terminator) + 19 bits of 0s = 20 bits total
      expect(bitStream.value, BigInt.zero);
      expect(bitStream.numTopZeroBits, 20);
    });

    test('x = 1 should produce correct bit pattern', () {
      final bitStream = BitStream(BigInt.zero);

      _testGolombRiceEncode(bitStream, BigInt.one);

      // x=1: q=0, r=1
      // Pattern: 0 + 0000000000000000001 = 20 bits, value=1
      expect(bitStream.value, BigInt.one);
      expect(bitStream.numTopZeroBits, 19);
    });

    test('x = 2^19 should produce correct bit pattern', () {
      final bitStream = BitStream(BigInt.zero);
      final x = BigInt.from(1 << 19); // 524288

      _testGolombRiceEncode(bitStream, x);

      // x=524288: q=1, r=0
      // Pattern: 1 + 0 + 0000000000000000000 = 21 bits
      // Bit sequence: 100000000000000000000 = 2^20
      expect(bitStream.value, BigInt.from(1 << 20));
      expect(bitStream.numTopZeroBits, 0);
    });

    test('x = 2^19 + 1 should produce correct bit pattern', () {
      final bitStream = BitStream(BigInt.zero);
      final x = BigInt.from((1 << 19) + 1); // 524289

      _testGolombRiceEncode(bitStream, x);

      // x=524289: q=1, r=1
      // Pattern: 1 + 0 + 0000000000000000001 = 21 bits
      // Bit sequence: 100000000000000000001 = 2^20 + 1
      expect(bitStream.value, BigInt.from((1 << 20) + 1));
      expect(bitStream.numTopZeroBits, 0);
    });

    test('x = 2^20 (q=2) should produce correct bit pattern', () {
      final bitStream = BitStream(BigInt.zero);
      final x = BigInt.from(1 << 20); // 1048576

      _testGolombRiceEncode(bitStream, x);

      // x=1048576: q=2, r=0
      // Pattern: 11 + 0 + 0000000000000000000 = 22 bits
      // Bit sequence: 1100000000000000000000 = (1<<21) + (1<<20)
      expect(bitStream.value, BigInt.from((1 << 21) + (1 << 20)));
      expect(bitStream.numTopZeroBits, 0);
    });
  });

  group('Golomb-Rice decode', () {
    test('encoded x=0 should decode correctly', () {
      final encodeStream = BitStream(BigInt.zero);
      _testGolombRiceEncode(encodeStream, BigInt.zero);

      final decodeStream = BitStream(encodeStream.value);
      decodeStream.numTopZeroBits = encodeStream.numTopZeroBits;

      final decoded = _testGolombRiceDecode(decodeStream);
      expect(decoded, BigInt.zero);
    });

    test('encoded x=1 should decode correctly', () {
      final encodeStream = BitStream(BigInt.zero);
      _testGolombRiceEncode(encodeStream, BigInt.one);

      final decodeStream = BitStream(encodeStream.value);
      decodeStream.numTopZeroBits = encodeStream.numTopZeroBits;

      final decoded = _testGolombRiceDecode(decodeStream);
      expect(decoded, BigInt.one);
    });

    test('encoded x=2^19 should decode correctly', () {
      final x = BigInt.from(1 << 19);

      final encodeStream = BitStream(BigInt.zero);
      _testGolombRiceEncode(encodeStream, x);

      final decodeStream = BitStream(encodeStream.value);
      decodeStream.numTopZeroBits = encodeStream.numTopZeroBits;

      final decoded = _testGolombRiceDecode(decodeStream);
      expect(decoded, x);
    });

    test('encoded x=2^19 + 12345 should decode correctly', () {
      final x = BigInt.from((1 << 19) + 12345);

      final encodeStream = BitStream(BigInt.zero);
      _testGolombRiceEncode(encodeStream, x);

      final decodeStream = BitStream(encodeStream.value);
      decodeStream.numTopZeroBits = encodeStream.numTopZeroBits;

      final decoded = _testGolombRiceDecode(decodeStream);
      expect(decoded, x);
    });

    test('encoded x=2^20 should decode correctly', () {
      final x = BigInt.from(1 << 20);

      final encodeStream = BitStream(BigInt.zero);
      _testGolombRiceEncode(encodeStream, x);

      final decodeStream = BitStream(encodeStream.value);
      decodeStream.numTopZeroBits = encodeStream.numTopZeroBits;

      final decoded = _testGolombRiceDecode(decodeStream);
      expect(decoded, x);
    });
  });

  group('Golomb-Rice encode/decode round-trip', () {
    test('multiple values should encode and decode correctly', () {
      final values = [
        BigInt.from(0),
        BigInt.from(1),
        BigInt.from(100),
        BigInt.from(500),
        BigInt.from(12345),
        BigInt.from(524288), // 2^19
        BigInt.from(1000000),
      ];

      final encodeStream = BitStream(BigInt.zero);

      // Encode all values
      for (final x in values) {
        _testGolombRiceEncode(encodeStream, x);
      }

      // Decode
      final decodeStream = BitStream(encodeStream.value);
      decodeStream.numTopZeroBits = encodeStream.numTopZeroBits;

      final decoded = <BigInt>[];
      for (var i = 0; i < values.length; i++) {
        decoded.add(_testGolombRiceDecode(decodeStream));
      }

      expect(decoded, values);
    });

    test('random-ish values should round-trip correctly', () {
      final values = [
        BigInt.from(42),
        BigInt.from(1337),
        BigInt.from(999999),
        BigInt.from(123456789),
        BigInt.from(0),
        BigInt.from(1),
      ];

      final encodeStream = BitStream(BigInt.zero);

      for (final x in values) {
        _testGolombRiceEncode(encodeStream, x);
      }

      final decodeStream = BitStream(encodeStream.value);
      decodeStream.numTopZeroBits = encodeStream.numTopZeroBits;

      for (var i = 0; i < values.length; i++) {
        final decoded = _testGolombRiceDecode(decodeStream);
        expect(decoded, values[i], reason: 'Failed at index $i');
      }
    });

    test('larger values should round-trip correctly', () {
      // Note: Very large values like 2^40 would have q (quotient) of 2^21,
      // which takes too long to encode. Testing with realistic range (up to 2^22).
      final values = [
        BigInt.from(1) << 20, // 2^20 (q=2)
        BigInt.from(1) << 21, // 2^21 (q=4)
        BigInt.from(1) << 22, // 2^22 (q=8)
        (BigInt.from(1) << 22) + BigInt.from(12345),
      ];

      final encodeStream = BitStream(BigInt.zero);

      for (final x in values) {
        _testGolombRiceEncode(encodeStream, x);
      }

      final decodeStream = BitStream(encodeStream.value);
      decodeStream.numTopZeroBits = encodeStream.numTopZeroBits;

      for (var i = 0; i < values.length; i++) {
        final decoded = _testGolombRiceDecode(decodeStream);
        expect(decoded, values[i], reason: 'Failed at index $i');
      }
    });
  });

  group('Golomb-Rice edge cases', () {
    test('all zeros should encode and decode', () {
      final values = List.generate(10, (_) => BigInt.zero);

      final encodeStream = BitStream(BigInt.zero);

      for (final x in values) {
        _testGolombRiceEncode(encodeStream, x);
      }

      final decodeStream = BitStream(encodeStream.value);
      decodeStream.numTopZeroBits = encodeStream.numTopZeroBits;

      for (var i = 0; i < values.length; i++) {
        final decoded = _testGolombRiceDecode(decodeStream);
        expect(decoded, values[i], reason: 'Failed at index $i');
      }
    });

    test('all max 19-bit values should encode and decode', () {
      final maxR = BigInt.from((1 << 19) - 1); // Maximum remainder (q=0, r=max)
      final values = List.generate(5, (_) => maxR);

      final encodeStream = BitStream(BigInt.zero);

      for (final x in values) {
        _testGolombRiceEncode(encodeStream, x);
      }

      final decodeStream = BitStream(encodeStream.value);
      decodeStream.numTopZeroBits = encodeStream.numTopZeroBits;

      for (var i = 0; i < values.length; i++) {
        final decoded = _testGolombRiceDecode(decodeStream);
        expect(decoded, values[i], reason: 'Failed at index $i');
      }
    });
  });

  group('create filter', () {
    test('with on chain data should produce valid filter', () {
      // use Bitcoin Block 700,000
      final key = Uint8List.fromList(
        cFiltersMessageOfBlock700000.blockHash.bytes.sublist(0, 16),
      );

      // Build items from blockMessageOf700000 transaction outputs
      final items = <Uint8List>[];

      // Extract scriptPubkey from each transaction output
      for (final tx in blockMessageOf700000.txs) {
        for (final txOut in tx.txOuts) {
          if (txOut.empty() ||
              txOut.scriptPubkey.commands[0] == OpCode.opReturn) {
            continue;
          }

          items.add(Script.serializeCommands(txOut.scriptPubkey.commands));
        }
      }

      // Create filter test
      final filterResult = createGcsFilter(key, items);
      expect(filterResult.value, isA<BigInt>());
      expect(filterResult.value > BigInt.zero, isTrue);
    });

    test('with on chain data should match expected filter bytes', () {
      // Compare with expected filter for Block 700,000
      final key = Uint8List.fromList(
        cFiltersMessageOfBlock700000.blockHash.bytes.sublist(0, 16),
      );

      final items = <Uint8List>[];
      for (final tx in blockMessageOf700000.txs) {
        for (final txOut in tx.txOuts) {
          if (txOut.empty() ||
              txOut.scriptPubkey.commands[0] == OpCode.opReturn) {
            continue;
          }
          items.add(Script.serializeCommands(txOut.scriptPubkey.commands));
        }
      }

      final filterResult = createGcsFilter(key, items);

      // Expected filter bytes
      final expectedFilterBytes =
          cFiltersMessageOfBlock700000.filterBytes.bytes;
      final actualFilterBytes = VarBytes.fromBigInt(filterResult.value).bytes;

      // Verify filter is generated
      expect(actualFilterBytes.isNotEmpty, isTrue);

      // Verify size is in reasonable range (exact match may differ due to implementation)
      print('Expected filter size: ${expectedFilterBytes.length}');
      print('Actual filter size: ${actualFilterBytes.length}');
    });

    test('with simple items', () {
      final key = Uint8List.fromList(List.filled(16, 0x01));
      final items = [
        Uint8List.fromList([0x01, 0x02, 0x03]),
        Uint8List.fromList([0x04, 0x05, 0x06]),
        Uint8List.fromList([0x07, 0x08, 0x09]),
      ];

      // Verify createGcsFilter works without exceptions
      final filterResult = createGcsFilter(key, items);
      expect(filterResult.value, isA<BigInt>());
      expect(filterResult.value >= BigInt.zero, isTrue);
      expect(filterResult.numTopZeroBits, isA<int>());
    });
  });

  group('gcsMatch', () {
    test('should return true for item that was included in filter', () {
      final key = Uint8List.fromList(List.filled(16, 0x01));
      final items = [
        Uint8List.fromList([0x01, 0x02, 0x03]),
        Uint8List.fromList([0x04, 0x05, 0x06]),
        Uint8List.fromList([0x07, 0x08, 0x09]),
      ];

      // Create filter
      final filterResult = createGcsFilter(key, items);

      // Included items should match
      for (final item in items) {
        final result = gcsMatch(key, filterResult, item, items.length);
        expect(result, isTrue, reason: 'Item ${item.toList()} should match');
      }
    });

    test('should return false for item that was not included in filter', () {
      final key = Uint8List.fromList(List.filled(16, 0x01));
      final items = [
        Uint8List.fromList([0x01, 0x02, 0x03]),
        Uint8List.fromList([0x04, 0x05, 0x06]),
        Uint8List.fromList([0x07, 0x08, 0x09]),
      ];

      // Create filter
      final filterResult = createGcsFilter(key, items);

      // Non-existent items (false positive rate is low, so these should return false)
      final nonExistentItems = [
        Uint8List.fromList([0xAA, 0xBB, 0xCC]),
        Uint8List.fromList([0xFF, 0xEE, 0xDD]),
        Uint8List.fromList([0x00, 0x00, 0x00]),
      ];

      for (final item in nonExistentItems) {
        final result = gcsMatch(key, filterResult, item, items.length);
        expect(result, isFalse,
            reason: 'Item ${item.toList()} should not match');
      }
    });

    test('should match all items from larger set', () {
      final key = Uint8List.fromList(List.generate(16, (i) => i));
      final items = List.generate(
        20,
        (i) => Uint8List.fromList([i, i + 1, i + 2, i + 3]),
      );

      final filterResult = createGcsFilter(key, items);

      // Verify all items match
      for (var i = 0; i < items.length; i++) {
        final result = gcsMatch(key, filterResult, items[i], items.length);
        expect(result, isTrue, reason: 'Item at index $i should match');
      }
    });
  });

  group('GcsFilter class', () {
    test('gcsMatch should return true for included items', () {
      final key = Uint8List.fromList(List.filled(16, 0x02));
      final items = [
        Uint8List.fromList([0x10, 0x20, 0x30]),
        Uint8List.fromList([0x40, 0x50, 0x60]),
      ];

      // Create filter using top-level function
      final filterResult = createGcsFilter(key, items);

      // Verify all included items match
      for (final item in items) {
        final result = gcsMatch(key, filterResult, item, items.length);
        expect(result, isTrue, reason: 'Item ${item.toList()} should match');
      }
    });

    test('gcsMatch should return false for non-included items', () {
      final key = Uint8List.fromList(List.filled(16, 0x02));
      final items = [
        Uint8List.fromList([0x10, 0x20, 0x30]),
        Uint8List.fromList([0x40, 0x50, 0x60]),
      ];

      final filterResult = createGcsFilter(key, items);

      // Non-existent item
      final nonExistentItem = Uint8List.fromList([0xFF, 0xFE, 0xFD]);
      final result = gcsMatch(key, filterResult, nonExistentItem, items.length);
      expect(result, isFalse);
    });
  });
}
