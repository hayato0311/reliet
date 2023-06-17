import 'dart:math' as math;
import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'bases/uint32le.dart';
import 'var_bytes.dart';

const ln2Squared = 0.4804530139182014246671025263266649717305529515945455;
const ln2 = 0.6931471805599453094172321214581765680755001343602552;
const maxBloomFilterSize = 36000; // bytes
const maxHashFuncs = 50;

@immutable
class BloomFilter {
  const BloomFilter({
    required this.nHashFuncs,
    required this.nTweak,
    required this.data,
    required this.nFlags,
  });

  factory BloomFilter.create({
    required Uint32le nElements,
    double nFPRate = 0.000001,
    required Uint32le nTweak,
    required BloomFlag nFlags,
  }) {
    var dataSize = (-1 / ln2Squared * nElements.value * math.log(nFPRate)) ~/ 8;
    dataSize = math.min(dataSize, maxBloomFilterSize * 8);
    final data = Uint8List(dataSize);

    final nHashFuncs = math.min(
      (data.length * 8 / nElements.value * ln2).toInt(),
      maxHashFuncs,
    );
    return BloomFilter(
      nHashFuncs: Uint32le(nHashFuncs),
      nTweak: nTweak,
      data: VarBytes(data.toList()),
      nFlags: nFlags,
    );
  }

  final Uint32le nHashFuncs;
  final Uint32le nTweak;
  final VarBytes data;
  final BloomFlag nFlags;

  void add(String item) {}

  bool contains(String item) {
    return false;
  }

  int hash(int nHashNum, Uint8List dataToHash) {
    return murmurHash3(
          nHashNum * 0xFBA4C795 + nTweak.value,
          dataToHash,
        ) %
        (data.length.value * 8);
  }
}

// int rotateLeft32(int x, int r) {
//   assert(x <= 0xFFFFFFFF, 'x must be a 32-bit integer');
//   return ((x << r) & 0xFFFFFFFF) | (x >> (32 - r));
// }

int rotl32(int x, int r) {
  assert(x <= 0xFFFFFFFF, 'x must be a 32-bit integer');
  return (x << r) | (x >> (32 - r));
}

int murmurHash3(int hashSeed, Uint8List dataToHash) {
  var h1 = hashSeed;
  const c1 = 0xcc9e2d51;
  const c2 = 0x1b873593;

  final nblocks = dataToHash.length ~/ 4;

  for (var i = 0; i < nblocks; ++i) {
    var k1 = (dataToHash[i * 4] << 24) |
        (dataToHash[i * 4 + 1] << 16) |
        (dataToHash[i * 4 + 2] << 8) |
        dataToHash[i * 4 + 3];

    k1 *= c1;
    k1 = rotl32(k1, 15);
    k1 *= c2;

    h1 ^= k1;
    h1 = rotl32(h1, 13);
    h1 = h1 * 5 + 0xe6546b64;
  }

  final tailIndex = nblocks * 4;

  var k1 = 0;

  switch (dataToHash.length & 3) {
    case 3:
      k1 ^= dataToHash[tailIndex + 2] << 16;
      continue case2;
    case2:
    case 2:
      k1 ^= dataToHash[tailIndex + 1] << 8;
      continue case1;
    case1:
    case 1:
      k1 ^= dataToHash[tailIndex];
      k1 *= c1;
      k1 = rotl32(k1, 15);
      k1 *= c2;
      h1 ^= k1;
  }

  h1 ^= dataToHash.length;
  h1 ^= h1 >> 16;
  h1 *= 0x85ebca6b;
  h1 ^= h1 >> 13;
  h1 *= 0xc2b2ae35;
  h1 ^= h1 >> 16;

  return h1;
}

enum BloomFlag {
  // Never update the filter with outpoints.
  none(0),
  // Always update the filter with outpoints.
  all(1),
  // Only update the filter with outpoints if it is P2PK or P2MS
  pubKeyOnly(2);

  const BloomFlag(this.value);

  static BloomFlag deserialize(Uint8List bytes) {
    final value = bytes[0];
    switch (value) {
      case 0:
        return BloomFlag.none;
      case 1:
        return BloomFlag.all;
      case 2:
        return BloomFlag.pubKeyOnly;
      default:
        throw Exception('Invalid BloomFlag value: $value');
    }
  }

  static int bytesLength() => 1;

  final int value;

  Map<String, dynamic> toJson() => {'value': value};

  Uint8List serialize() => Uint8List.fromList([value]);
}
