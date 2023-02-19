import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/messages/get_data_message.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/hash256.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/inventory.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/inventory_type.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_integer.dart';

void main() {
  group('create and serialize GetDataMessage instance', () {
    test('with valid args', () {
      final inventories = [
        Inventory(
          InventoryType.transaction,
          Hash256.create(const [1, 2, 3, 4]),
        ),
        Inventory(
          InventoryType.transaction,
          Hash256.create(const [1, 1, 1, 1]),
        ),
      ];
      final count = VarInt(inventories.length);

      final getDataMessage = GetDataMessage(inventories);

      final serializedGetDataMessage = <int>[
        ...count.serialize(),
        for (var inventory in inventories) ...inventory.serialize(),
      ];

      expect(
        getDataMessage.serialize(),
        Uint8List.fromList(serializedGetDataMessage),
      );
    });
  });

  group('deserialize bytes to GetDataMessage instance', () {
    test('with valid bytes', () {
      final inventories = [
        Inventory(
          InventoryType.transaction,
          Hash256.create(const [1, 2, 3, 4]),
        ),
        Inventory(InventoryType.transaction, Hash256.create(const [1, 1, 1, 1]))
      ];

      final getDataMessage = GetDataMessage(inventories);

      final serializedGetDataMessage = getDataMessage.serialize();

      final deserializedGetDataMessage =
          GetDataMessage.deserialize(serializedGetDataMessage);

      expect(deserializedGetDataMessage, isA<GetDataMessage>());
    });
    test('with invalid bytes', () {
      expect(
        () => GetDataMessage.deserialize(Uint8List.fromList([0, 0, 0, 1])),
        throwsArgumentError,
      );
    });
  });
}
