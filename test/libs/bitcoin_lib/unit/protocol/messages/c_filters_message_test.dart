import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/messages/c_filters_message.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/filter_type.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/hash256.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/var_bytes.dart';

void main() {
  group('create and serialize CFilterMessage instance', () {
    test('with valid args', () {
      const filterType = FilterType.basic;
      final blockHash = Hash256.create(const [0, 1, 1, 1, 1]);
      final filterBytes = VarBytes(Uint8List.fromList([0, 1, 1, 1, 1]));

      final cFilterMessage = CFilterMessage(
        filterType: filterType,
        blockHash: blockHash,
        filterBytes: filterBytes,
      );

      expect(
        cFilterMessage.serialize(),
        Uint8List.fromList([
          ...filterType.serialize(),
          ...blockHash.serialize(),
          ...filterBytes.serialize(),
        ]),
      );
    });
  });
  group('deserialize bytes to BlockMessage instance', () {
    test('with valid bytes', () {
      const filterType = FilterType.basic;
      final blockHash = Hash256.create(const [0, 1, 1, 1, 1]);
      final filterBytes = VarBytes(Uint8List.fromList([0, 1, 1, 1, 1]));

      final serializedCFilterMessage = CFilterMessage(
        filterType: filterType,
        blockHash: blockHash,
        filterBytes: filterBytes,
      ).serialize();

      final deserializedCFilterMessage = CFilterMessage.deserialize(
        Uint8List.fromList(serializedCFilterMessage),
      );

      expect(deserializedCFilterMessage, isA<CFilterMessage>());
      expect(
        deserializedCFilterMessage.filterType.value,
        filterType.value,
      );
      expect(
        deserializedCFilterMessage.blockHash.bytes,
        blockHash.bytes,
      );
      expect(
        deserializedCFilterMessage.filterBytes.bytes,
        filterBytes.bytes,
      );
    });
    test('with invalid bytes', () {
      expect(
        () => CFilterMessage.deserialize(Uint8List.fromList([0, 0, 0, 1])),
        throwsArgumentError,
      );
    });
  });
}
