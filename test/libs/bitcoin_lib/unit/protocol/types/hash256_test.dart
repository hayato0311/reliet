import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/hash256.dart';

void main() {
  final input = <int>[113, 17, 1, 0];

  final ans = <int>[
    170,
    129,
    213,
    95,
    248,
    250,
    162,
    214,
    61,
    190,
    12,
    174,
    122,
    158,
    23,
    120,
    93,
    69,
    9,
    186,
    106,
    208,
    210,
    245,
    173,
    201,
    29,
    105,
    76,
    115,
    255,
    114
  ];
  group('create and serialize Hash256 instance ', () {
    group('by create factory constructor', () {
      test('with valid params', () {
        final hash = Hash256.create(input);
        expect(hash.bytes, Uint8List.fromList(ans));
        expect(hash.bytes, Uint8List.fromList(ans));
        expect(hash.serialize(), Uint8List.fromList(ans.reversed.toList()));
      });
    });
    group('by fromHexString factory constructor', () {
      test('with valid params', () {
        const hexStringHash =
            'aa81d55ff8faa2d63dbe0cae7a9e17785d4509ba6ad0d2f5adc91d694c73ff72';
        final hash = Hash256.fromHexString(hexStringHash);
        expect(hash.bytes, Uint8List.fromList(ans));
        expect(hash.serialize(), Uint8List.fromList(ans.reversed.toList()));
        expect(hash.toJson()['bytes'], hexStringHash);
      });
    });
  });
  group('deserialize bytes to Hash256 instance', () {
    test('with valid bytes', () {
      final hash = Hash256.create(input);
      final serializedHash = hash.serialize();

      expect(Hash256.deserialize(serializedHash), isA<Hash256>());
      expect(Hash256.deserialize(serializedHash).bytes, ans);
    });

    test('with invalid bytes', () {
      expect(
        () => Hash256.deserialize(Uint8List.fromList([0, 0, 0, 1])),
        throwsArgumentError,
      );
    });
  });
}
