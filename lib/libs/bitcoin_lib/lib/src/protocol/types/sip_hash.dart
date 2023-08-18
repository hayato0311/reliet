import 'dart:typed_data';

import '../../extensions/big_int_extensions.dart';
import '../../extensions/uint8_list_extensions.dart';

const cRounds = 2;
const dRounds = 4;

class SipHash {
  // Meaning of arguments in BIP158:
  // key: The first 16 bytes of the block hash
  // data: Script pubkey
  factory SipHash({required Uint8List key, required Uint8List data}) {
    if (key.length != 16) {
      throw ArgumentError('Key must be 16 bytes');
    }

    final k0 = BigInt.parse(
      Uint8List.fromList(key.sublist(0, 8).reversed.toList()).toHex(),
    );
    final k1 = BigInt.parse(
      Uint8List.fromList(key.sublist(8).reversed.toList()).toHex(),
    );

    var v = [
      k0 ^ BigInt.parse('0x736f6d6570736575'),
      k1 ^ BigInt.parse('0x646f72616e646f6d'),
      k0 ^ BigInt.parse('0x6c7967656e657261'),
      k1 ^ BigInt.parse('0x7465646279746573')
    ];

    v = _compression(v, data);

    final result = _finalization(v);

    return SipHash._internal(result.toUint8List());
  }

  const SipHash._internal(this.bytes);

  final Uint8List bytes;

  static List<BigInt> _compression(List<BigInt> v, Uint8List data) {
    for (var i = 0; i < data.length; i += 8) {
      BigInt mi;

      if (i + 8 < data.length - 1) {
        mi = BigInt.parse(
          Uint8List.fromList(data.sublist(i, i + 8).reversed.toList()).toHex(),
        );
      } else {
        final lastBytes = Uint8List.fromList(
          List<int>.filled(7 - (data.length - 1 - i), 0) + [data.length % 256],
        );

        if ((data.sublist(i) + lastBytes).length != 8) {
          print('error');
        }

        mi = BigInt.parse(
          Uint8List.fromList(
            (data.sublist(i) + lastBytes).reversed.toList(),
          ).toHex(),
        );
      }

      v[3] ^= mi;
      for (var i = 0; i < cRounds; i++) {
        // ignore: parameter_assignments
        v = _sipRound(v);
      }
      v[0] ^= mi;
    }
    return v;
  }

  static BigInt _finalization(List<BigInt> v) {
    v[2] ^= BigInt.from(0xff);
    for (var i = 0; i < dRounds; i++) {
      // ignore: parameter_assignments
      v = _sipRound(v);
    }
    return v[0] ^ v[1] ^ v[2] ^ v[3];
  }

  static List<BigInt> _sipRound(List<BigInt> v) {
    v[0] += v[1];
    v[2] += v[3];
    v[1] = _rotateLeft(v[1], 13) ^ v[0];
    v[3] = _rotateLeft(v[3], 16) ^ v[2];
    v[0] = _rotateLeft(v[0], 32);
    v[2] += v[1];
    v[0] += v[3];
    v[1] = _rotateLeft(v[1], 17) ^ v[2];
    v[3] = _rotateLeft(v[3], 21) ^ v[0];
    v[2] = _rotateLeft(v[2], 32);
    return v;
  }

  static BigInt _rotateLeft(BigInt x, int b) => (x << b) | (x >> (64 - b));
}
