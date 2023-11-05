import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/messages/get_c_filters_message.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/bases/uint32le.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/filter_type.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/hash256.dart';

void main() {
  group('create and serialize GetCFiltersMessage instance', () {
    test('with valid args', () {
      const filterType = FilterType.basic;
      final startHeight = Uint32le(1);
      final stopHash = Hash256.create(const [0, 1, 1, 1, 1]);

      final getCFiltersMessage = GetCFiltersMessage(
        filterType: filterType,
        startHeight: startHeight,
        stopHash: stopHash,
      );

      expect(
        getCFiltersMessage.serialize(),
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

      final serializedGetCFiltersMessage = GetCFiltersMessage(
        filterType: filterType,
        startHeight: startHeight,
        stopHash: stopHash,
      ).serialize();

      final deserializedGetCFiltersMessage = GetCFiltersMessage.deserialize(
        Uint8List.fromList(serializedGetCFiltersMessage),
      );

      expect(deserializedGetCFiltersMessage, isA<GetCFiltersMessage>());
      expect(
        deserializedGetCFiltersMessage.filterType.value,
        filterType.value,
      );
      expect(
        deserializedGetCFiltersMessage.startHeight.value,
        startHeight.value,
      );
      expect(
        deserializedGetCFiltersMessage.stopHash.bytes,
        stopHash.bytes,
      );
    });
    test('with invalid bytes', () {
      expect(
        () => GetCFiltersMessage.deserialize(Uint8List.fromList([0, 0, 0, 1])),
        throwsArgumentError,
      );
    });
  });
}
