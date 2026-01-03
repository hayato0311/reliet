import 'dart:typed_data';

import 'package:meta/meta.dart';

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

/// Match against a filter received from network (VarBytes format)
bool gcsMatchFromBytes(
  Uint8List key,
  VarBytes filterBytes,
  Uint8List target,
  int numItems,
) {
  if (key.length != 16) {
    throw ArgumentError('Key must be 16 bytes');
  }
  if (filterBytes.bytes.isEmpty) {
    return false;
  }

  final value = filterBytes.toBigInt();
  final bitStream = BitStream(value);
  // Calculate numTopZeroBits from byte length and bit length
  // Total bits = bytes.length * 8, actual bits = value.bitLength
  bitStream.numTopZeroBits = (filterBytes.bytes.length * 8) - value.bitLength;

  return _gcsMatchInternal(bitStream, key, target, numItems);
}

bool _gcsMatchInternal(
  BitStream bitStream,
  Uint8List key,
  Uint8List target,
  int numItems,
) {
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

// ============================================================================
// Testing utilities
// The following functions are used for testing purposes to verify that
// the encoding/decoding logic is correct. In production, SPV clients only
// receive pre-built filters from full nodes and use gcsMatchFromBytes.
// ============================================================================

/// Return value of createGcsFilter
@visibleForTesting
class GcsFilterResult {
  GcsFilterResult(this.value, this.numTopZeroBits);
  final BigInt value;
  final int numTopZeroBits;
}

/// Create a GCS filter from items.
/// This is a full node operation, kept here for testing encode/decode round-trip.
@visibleForTesting
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

/// Match target against a GcsFilterResult.
/// Used for testing round-trip correctness (create -> match).
/// In production, use gcsMatchFromBytes instead.
@visibleForTesting
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

  return _gcsMatchInternal(bitStream, key, target, numItems);
}

void _golombRiceEncode(BitStream bitStream, BigInt x) {
  var q = x >> p;
  while (q > BigInt.zero) {
    bitStream.write(BigInt.parse('1', radix: 2));
    q -= BigInt.one;
  }
  bitStream.write(BigInt.parse('0', radix: 2));
  bitStream.writeTailBits(x, p);
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
