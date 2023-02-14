import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/messages/inv_message.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/hash256.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/inventory.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/inventory_type.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_integer.dart';

void main() {
  group('create and serialize InvMessage instance', () {
    test('with valid args', () {
      final inventories = [
        Inventory(InventoryType.transaction, Hash256.create([1, 2, 3, 4])),
        Inventory(InventoryType.transaction, Hash256.create([1, 1, 1, 1])),
      ];
      final count = VarInt(inventories.length);

      final invMessage = InvMessage(inventories);

      final serializedInvMessage = <int>[
        ...count.serialize(),
        for (var inventory in inventories) ...inventory.serialize(),
      ];

      expect(
        invMessage.serialize(),
        Uint8List.fromList(serializedInvMessage),
      );
    });
  });

  group('deserialize bytes to InvMessage instance', () {
    test('with valid bytes', () {
      final inventories = [
        Inventory(InventoryType.transaction, Hash256.create([1, 2, 3, 4])),
        Inventory(InventoryType.transaction, Hash256.create([1, 1, 1, 1]))
      ];

      final invMessage = InvMessage(inventories);

      final serializedInvMessage = invMessage.serialize();

      final deserializedInvMessage =
          InvMessage.deserialize(serializedInvMessage);

      expect(deserializedInvMessage, isA<InvMessage>());
    });
    test('with invalid bytes', () {
      expect(
        () => InvMessage.deserialize(Uint8List.fromList([0, 0, 0, 1])),
        throwsArgumentError,
      );
    });
  });
}
