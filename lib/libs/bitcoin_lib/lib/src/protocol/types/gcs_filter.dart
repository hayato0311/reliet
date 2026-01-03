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

    final f = BigInt.from(numItems) * BigInt.from(m);
    final targetHashValue = _hashToRange(target, f, key);

    var lastValue = BigInt.zero;

    for (var i = 0; i < numItems; i++) {
      final delta = _golombRiceDecode();
      final setItem = lastValue + delta;

      if (setItem == targetHashValue) {
        return true;
      }

      // Since the values in the set are sorted, terminate the search once
      // the decoded value exceeds the target.
      if (setItem > targetHashValue) {
        break;
      }

      lastValue = setItem;
    }
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
    final hash = SipHash(key: key, data: item).bytes;
    final multipliedHash = BigInt.parse(hash.toHex()) * (f & mask);
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

/// Return value of createGcsFilter
class GcsFilterResult {
  GcsFilterResult(this.value, this.numTopZeroBits);
  final BigInt value;
  final int numTopZeroBits;
}

GcsFilterResult createGcsFilter(Uint8List key, List<Uint8List> items) {
  final hashedItems = _buildHashedItems(key, items);
  hashedItems.sort();

  final bitStream = BitStream(BigInt.zero);
  var lastValue = BigInt.zero;
  for (final value in hashedItems) {
    final delta = value - lastValue;
    _golombRiceEncode(bitStream, delta);
    lastValue = value;
  }
  return GcsFilterResult(bitStream.value, bitStream.numTopZeroBits);
}

bool gcsMatch(
  Uint8List key,
  GcsFilterResult filterResult,
  Uint8List target,
  int numItems,
) {
  if (key.length != 16) {
    throw ArgumentError('Key must be 16 bytes');
  }
  final bitStream = BitStream(filterResult.value);
  bitStream.numTopZeroBits = filterResult.numTopZeroBits;

  final f = BigInt.from(numItems) * BigInt.from(m);
  final targetHashValue = _hashToRange(target, f, key);

  var lastValue = BigInt.zero;

  for (var i = 0; i < numItems; i++) {
    final delta = _golombRiceDecode(bitStream);
    final setItem = lastValue + delta;

    if (setItem == targetHashValue) {
      return true;
    }

    // Since the values in the set are sorted, terminate the search once
    // the decoded value exceeds the target.
    if (setItem > targetHashValue) {
      break;
    }

    lastValue = setItem;
  }
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
  while (bitStream.read(1) == BigInt.one) {
    q += BigInt.one;
  }

  final r = bitStream.read(p);

  return ((q << p) | r) & mask;
}

BigInt _hashToRange(Uint8List item, BigInt f, Uint8List key) {
  final hash = SipHash(key: key, data: item).bytes;
  final multipliedHash = BigInt.parse(hash.toHex()) * (f & mask);
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
