import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/messages/get_c_f_header_message.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/bases/uint32le.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/filter_type.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/hash256.dart';

void main() {
  group('create and serialize GetCFHeadersMessage instance', () {
    test('with valid args', () {
      const filterType = FilterType.basic;
      final startHeight = Uint32le(1);
      final stopHash = Hash256.create(const [0, 1, 1, 1, 1]);

      final getCFHeadersMessage = GetCFHeadersMessage(
        filterType: filterType,
        startHeight: startHeight,
        stopHash: stopHash,
      );

      expect(
        getCFHeadersMessage.serialize(),
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

      final serializedGetCFilterMessage = GetCFHeadersMessage(
        filterType: filterType,
        startHeight: startHeight,
        stopHash: stopHash,
      ).serialize();

      final deserializedGetCFilterMessage = GetCFHeadersMessage.deserialize(
        Uint8List.fromList(serializedGetCFilterMessage),
      );

      expect(deserializedGetCFilterMessage, isA<GetCFHeadersMessage>());
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
        () => GetCFHeadersMessage.deserialize(Uint8List.fromList([0, 0, 0, 1])),
        throwsArgumentError,
      );
    });
  });
}
