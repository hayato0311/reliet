import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/inventory_type.dart';

void main() {
  group('create and serialize InventoryType instance', () {
    test('of error', () {
      const inventoryTypeValue = 0;
      const inventoryType = InventoryType.error;
      final serializedInventoryType = inventoryType.serialize();

      expect(inventoryType.value, inventoryTypeValue);
      expect(serializedInventoryType, inventoryTypeValue.toUint32leBytes());
    });
    test('of transaction', () {
      const inventoryTypeValue = 1;
      const inventoryType = InventoryType.transaction;
      final serializedInventoryType = inventoryType.serialize();

      expect(inventoryType.value, inventoryTypeValue);
      expect(serializedInventoryType, inventoryTypeValue.toUint32leBytes());
    });
    test('of block', () {
      const inventoryTypeValue = 2;
      const inventoryType = InventoryType.block;
      final serializedInventoryType = inventoryType.serialize();

      expect(inventoryType.value, inventoryTypeValue);
      expect(serializedInventoryType, inventoryTypeValue.toUint32leBytes());
    });
    test('of filterdBlock', () {
      const inventoryTypeValue = 3;
      const inventoryType = InventoryType.filterdBlock;
      final serializedInventoryType = inventoryType.serialize();

      expect(inventoryType.value, inventoryTypeValue);
      expect(serializedInventoryType, inventoryTypeValue.toUint32leBytes());
    });
    test('of compactBlock', () {
      const inventoryTypeValue = 4;
      const inventoryType = InventoryType.compactBlock;
      final serializedInventoryType = inventoryType.serialize();

      expect(inventoryType.value, inventoryTypeValue);
      expect(serializedInventoryType, inventoryTypeValue.toUint32leBytes());
    });
    test('of witnessTransaction', () {
      const inventoryTypeValue = 0x40000001;
      const inventoryType = InventoryType.witnessTransaction;
      final serializedInventoryType = inventoryType.serialize();

      expect(inventoryType.value, inventoryTypeValue);
      expect(serializedInventoryType, inventoryTypeValue.toUint32leBytes());
    });

    test('of witnessBlock', () {
      const inventoryTypeValue = 0x40000002;
      const inventoryType = InventoryType.witnessBlock;
      final serializedInventoryType = inventoryType.serialize();

      expect(inventoryType.value, inventoryTypeValue);
      expect(serializedInventoryType, inventoryTypeValue.toUint32leBytes());
    });

    test('of filterdWitnessBlock', () {
      const inventoryTypeValue = 0x40000003;
      const inventoryType = InventoryType.filterdWitnessBlock;
      final serializedInventoryType = inventoryType.serialize();

      expect(inventoryType.value, inventoryTypeValue);
      expect(serializedInventoryType, inventoryTypeValue.toUint32leBytes());
    });
  });

  group('deserialize bytes to Command instance', () {
    test('of error', () {
      final serializedInventoryType = InventoryType.error.serialize();
      expect(
        InventoryType.deserialize(serializedInventoryType),
        InventoryType.error,
      );
    });

    test('of transaction', () {
      final serializedInventoryType = InventoryType.transaction.serialize();
      expect(
        InventoryType.deserialize(serializedInventoryType),
        InventoryType.transaction,
      );
    });

    test('of block', () {
      final serializedInventoryType = InventoryType.block.serialize();
      expect(
        InventoryType.deserialize(serializedInventoryType),
        InventoryType.block,
      );
    });
    test('of filterdBlock', () {
      final serializedInventoryType = InventoryType.filterdBlock.serialize();
      expect(
        InventoryType.deserialize(serializedInventoryType),
        InventoryType.filterdBlock,
      );
    });
    test('of compactBlock', () {
      final serializedInventoryType = InventoryType.compactBlock.serialize();
      expect(
        InventoryType.deserialize(serializedInventoryType),
        InventoryType.compactBlock,
      );
    });
    test('of witnessTransaction', () {
      final serializedInventoryType =
          InventoryType.witnessTransaction.serialize();
      expect(
        InventoryType.deserialize(serializedInventoryType),
        InventoryType.witnessTransaction,
      );
    });
    test('of witnessBlock', () {
      final serializedInventoryType = InventoryType.witnessBlock.serialize();
      expect(
        InventoryType.deserialize(serializedInventoryType),
        InventoryType.witnessBlock,
      );
    });
    test('of filterdWitnessBlock', () {
      final serializedInventoryType =
          InventoryType.filterdWitnessBlock.serialize();
      expect(
        InventoryType.deserialize(serializedInventoryType),
        InventoryType.filterdWitnessBlock,
      );
    });
  });
}
