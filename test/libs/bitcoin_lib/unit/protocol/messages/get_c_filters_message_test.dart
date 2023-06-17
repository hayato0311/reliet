import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/messages/get_c_filters_message.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/bases/uint32le.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/filter_type.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/hash256.dart';

void main() {
  group('create and serialize GetCFilterMessage instance', () {
    test('with valid args', () {
      const filterType = FilterType.basic;
      final startHeight = Uint32le(1);
      final stopHash = Hash256.create(const [0, 1, 1, 1, 1]);

      final getCFilterMessage = GetCFilterMessage(
        filterType: filterType,
        startHeight: startHeight,
        stopHash: stopHash,
      );

      expect(
        getCFilterMessage.serialize(),
        Uint8List.fromList([
          ...filterType.serialize(),
          ...startHeight.serialize(),
          ...stopHash.serialize(),
        ]),
      );
    });
  });
  group('deserialize bytes to BlockMessage instance', () {
    test('when valid', () {
      const filterType = FilterType.basic;
      final startHeight = Uint32le(1);
      final stopHash = Hash256.create(const [0, 1, 1, 1, 1]);

      final serializedGetCFilterMessage = GetCFilterMessage(
        filterType: filterType,
        startHeight: startHeight,
        stopHash: stopHash,
      ).serialize();

      final deserializedGetCFilterMessage = GetCFilterMessage.deserialize(
        Uint8List.fromList(serializedGetCFilterMessage),
      );

      expect(deserializedGetCFilterMessage, isA<GetCFilterMessage>());
      expect(
        deserializedGetCFilterMessage.filterType.value,
        filterType.value,
      );
      expect(
        deserializedGetCFilterMessage.startHeight.value,
        startHeight.value,
      );
      expect(
        deserializedGetCFilterMessage.stopHash.bytes,
        stopHash.bytes,
      );
    });
    test('with invalid bytes', () {
      expect(
        () => GetCFilterMessage.deserialize(Uint8List.fromList([0, 0, 0, 1])),
        throwsArgumentError,
      );
    });
  });
}
