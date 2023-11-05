import 'dart:typed_data';

import '../../extensions/big_int_extensions.dart';
import '../../extensions/uint8_list_extensions.dart';
import '../../utils/bit_stream.dart';
import 'sip_hash.dart';
import 'var_bytes.dart';

const m = 784931;
const p = 19;

final mask = BigInt.parse('0xFFFFFFFFFFFFFFFF');

// Variable meaning in BIP158:
// key: The first 16 bytes of the block hash
// item: data is constructed by concatenating the following items, in order:
//  1. The previous output script for each input,
//    except for the coinbase transaction.
//  2. The scriptPubKey of each output,
//     excluding all OP_RETURN output scripts.
class GcsFilter {
  GcsFilter();

  late BitStream bitStream;

  // Uint8List key;
  // VarBytes encodedFilter;

  void createFilter(Uint8List key, List<Uint8List> items) {
    final hashedItems = _buildHashedItems(key, items);
    hashedItems.sort();
    var lastValue = BigInt.zero;
    for (final value in hashedItems) {
      final delta = value - lastValue;
      _golombRiceEncode(delta);
      lastValue = value;
    }
  }

  bool gcsMatch(
    Uint8List key,
    VarBytes compressedSet,
    Uint8List target,
    int numItems,
  ) {
    if (key.length != 16) {
      throw ArgumentError('Key must be 16 bytes');
    }
    bitStream = BitStream(BigInt.parse(compressedSet.bytes.toHex()));

    print('compressedSet.bytes.length: ${compressedSet.bytes.length}');
    print('compressedSet.length.value: ${compressedSet.length.value}');

    // final numItems = compressedSet.length.value;

    final f = BigInt.from(numItems) * BigInt.from(m);
    final targetHashValue = _hashToRange(target, f, key);

    var lastValue = BigInt.zero;

    print('numItems: $numItems');
    print('bitStream bitLength: ${bitStream.value.bitLength}');

    for (var i = 0; i < numItems; i++) {
      final delta = _golombRiceDecode();
      final setItem = lastValue + delta;
      print('---');
      print('i: $i');
      print('delta: ${delta.toHex()}');
      print('setItem: ${setItem.toHex()}');
      print('targetHashValue: ${targetHashValue.toHex()}');

      if (setItem == targetHashValue) {
        return true;
      }

      // Since the values in the set are sorted, terminate the search once
      // the decoded value exceeds the target.
      if (setItem > targetHashValue) {
        print(setItem);
        print(targetHashValue);
        break;
      }

      lastValue = setItem;
    }
    print('---');
    print('bitStream.value.bitLength: ${bitStream.value.bitLength}');
    return false;
  }

  void _golombRiceEncode(BigInt x) {
    var q = x >> p;
    while (q > BigInt.zero) {
      bitStream.write(BigInt.parse('1', radix: 2));
      q -= BigInt.one;
    }
    bitStream.write(BigInt.parse('0', radix: 2));
    bitStream.write(x);
    bitStream.writeTailBits(x, p);
  }

  BigInt _golombRiceDecode() {
    var q = BigInt.zero;
    while (bitStream.read(1).toInt() == 1) {
      q += BigInt.one;
    }

    final r = bitStream.read(p);

    final x = (((q << p) & mask) + BigInt.parse(r.toHex())) & mask;

    return x;
  }

  BigInt _hashToRange(Uint8List item, BigInt f, Uint8List key) {
    print('item: $item');
    print('f: ${f.toHex()}');
    print('key: $key');

    final hash = SipHash(key: key, data: item).bytes;
    print('hash: $hash');
    print('hash.toHex(): ${hash.toHex()}');
    final multipliedHash = BigInt.parse(hash.toHex()) * (f & mask);
    print('multipliedHash: ${multipliedHash.toHex()}');
    print('(multipliedHash >> 64): ${(multipliedHash >> 64).toHex()}');
    return multipliedHash >> 64;
  }

  List<BigInt> _buildHashedItems(
    Uint8List key,
    List<Uint8List> items,
  ) {
    if (key.length != 16) {
      throw ArgumentError('Key must be 16 bytes');
    }
    bitStream = BitStream(BigInt.zero);

    final f = BigInt.from(items.length) * BigInt.from(m);

    final hashedItems = <BigInt>[];

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      hashedItems.add(_hashToRange(item, f, key));
    }
    return hashedItems;
  }
}

BigInt createGcsFilter(Uint8List key, List<Uint8List> items) {
  final hashedItems = _buildHashedItems(key, items);
  hashedItems.sort();

  final bitStream = BitStream(BigInt.zero);
  var lastValue = BigInt.zero;
  for (final value in hashedItems) {
    final delta = value - lastValue;
    _golombRiceEncode(bitStream, delta);
    lastValue = value;
  }
  return bitStream.value;
}

bool gcsMatch(
  Uint8List key,
  VarBytes compressedSet,
  Uint8List target,
  int numItems,
) {
  if (key.length != 16) {
    throw ArgumentError('Key must be 16 bytes');
  }
  final bitStream = BitStream(BigInt.parse(compressedSet.bytes.toHex()));

  print('compressedSet.bytes.length: ${compressedSet.bytes.length}');
  print('compressedSet.length.value: ${compressedSet.length.value}');

  // final numItems = compressedSet.length.value;

  final f = BigInt.from(numItems) * BigInt.from(m);
  final targetHashValue = _hashToRange(target, f, key);

  var lastValue = BigInt.zero;

  print('numItems: $numItems');
  print('bitStream bitLength: ${bitStream.value.bitLength}');

  for (var i = 0; i < numItems; i++) {
    final delta = _golombRiceDecode(bitStream);
    final setItem = lastValue + delta;
    print('---');
    print('i: $i');
    print('delta: ${delta.toHex()}');
    print('setItem: ${setItem.toHex()}');
    print('targetHashValue: ${targetHashValue.toHex()}');

    if (setItem == targetHashValue) {
      return true;
    }

    // Since the values in the set are sorted, terminate the search once
    // the decoded value exceeds the target.
    if (setItem > targetHashValue) {
      print(setItem);
      print(targetHashValue);
      break;
    }

    lastValue = setItem;
  }
  print('---');
  print('bitStream.value.bitLength: ${bitStream.value.bitLength}');
  return false;
}

void _golombRiceEncode(BitStream bitStream, BigInt x) {
  var q = x >> p;
  while (q > BigInt.zero) {
    bitStream.write(BigInt.parse('1', radix: 2));
    q -= BigInt.one;
  }
  bitStream.write(BigInt.parse('0', radix: 2));
  // bitStream.write(x); maybe not needed
  bitStream.writeTailBits(x, p);
}

BigInt _golombRiceDecode(BitStream bitStream) {
  var q = BigInt.zero;
  while (bitStream.read(1).toInt() == 1) {
    q += BigInt.one;
  }

  final r = bitStream.read(p);

  final x = (((q << p) & mask) + BigInt.parse(r.toHex())) & mask;

  return x;
}

BigInt _hashToRange(Uint8List item, BigInt f, Uint8List key) {
  print('item: $item');
  print('f: ${f.toHex()}');
  print('key: $key');

  final hash = SipHash(key: key, data: item).bytes;
  print('hash: $hash');
  print('hash.toHex(): ${hash.toHex()}');
  final multipliedHash = BigInt.parse(hash.toHex()) * (f & mask);
  print('multipliedHash: ${multipliedHash.toHex()}');
  print('(multipliedHash >> 64): ${(multipliedHash >> 64).toHex()}');
  return multipliedHash >> 64;
}

List<BigInt> _buildHashedItems(
  Uint8List key,
  List<Uint8List> items,
) {
  if (key.length != 16) {
    throw ArgumentError('Key must be 16 bytes');
  }

  final f = BigInt.from(items.length) * BigInt.from(m);

  final hashedItems = <BigInt>[];

  for (var i = 0; i < items.length; i++) {
    final item = items[i];
    hashedItems.add(_hashToRange(item, f, key));
  }
  return hashedItems;
}
