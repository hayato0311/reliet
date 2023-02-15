import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/hash256.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/inventory.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/inventory_type.dart';

void main() {
  group('create and serialize Inventory instance', () {
    test('with valid params', () {
      const type = InventoryType.transaction;
      final hash = Hash256.create(const [1, 1, 1, 1]);
      final inventory = Inventory(type, hash);

      final serializedInventory = <int>[
        ...type.serialize(),
        ...hash.serialize(),
      ];

      expect(
        inventory.serialize(),
        Uint8List.fromList(serializedInventory),
      );
    });
  });
  group('deserialize bytes to MessageHeader instance', () {
    test('with valid bytes', () {
      const type = InventoryType.transaction;
      final hash = Hash256.create(const [1, 1, 1, 1]);
      final inventory = Inventory(type, hash);

      final serializedInventory = inventory.serialize();

      expect(Inventory.deserialize(serializedInventory), isA<Inventory>());
    });
    test('with invalid bytes', () {
      expect(
        () => Inventory.deserialize(
          Uint8List.fromList([0, 0, 0, 1]),
        ),
        throwsArgumentError,
      );
    });
  });
}
