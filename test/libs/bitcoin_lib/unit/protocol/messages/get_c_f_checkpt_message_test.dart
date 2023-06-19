import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/messages/get_c_f_checkpt_message.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/filter_type.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/hash256.dart';

void main() {
  group('create and serialize GetCFCheckptMessage instance', () {
    test('with valid args', () {
      const filterType = FilterType.basic;
      final stopHash = Hash256.create(const [0, 1, 1, 1, 1]);

      final getCFHeadersMessage = GetCFCheckptMessage(
        filterType: filterType,
        stopHash: stopHash,
      );

      expect(
        getCFHeadersMessage.serialize(),
        Uint8List.fromList([
          ...filterType.serialize(),
          ...stopHash.serialize(),
        ]),
      );
    });
  });
  group('deserialize bytes to BlockMessage instance', () {
    test('when valid', () {
      const filterType = FilterType.basic;
      final stopHash = Hash256.create(const [0, 1, 1, 1, 1]);

      final serializedGetCFilterMessage = GetCFCheckptMessage(
        filterType: filterType,
        stopHash: stopHash,
      ).serialize();

      final deserializedGetCFilterMessage = GetCFCheckptMessage.deserialize(
        Uint8List.fromList(serializedGetCFilterMessage),
      );

      expect(deserializedGetCFilterMessage, isA<GetCFCheckptMessage>());
      expect(
        deserializedGetCFilterMessage.filterType.value,
        filterType.value,
      );
      expect(
        deserializedGetCFilterMessage.stopHash.bytes,
        stopHash.bytes,
      );
    });
    test('with invalid bytes', () {
      expect(
        () => GetCFCheckptMessage.deserialize(Uint8List.fromList([0, 0, 0, 1])),
        throwsArgumentError,
      );
    });
  });
}
