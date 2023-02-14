import 'dart:typed_data';

import '../../extensions/int_extensions.dart';

enum InventoryType {
  // Any data of with this number may be ignored
  error._internal(0),

  // Hash is related to a transaction
  transaction._internal(1),

  // Hash is related to a data block
  block._internal(2),

  // Hash of a block header; identical to MSG_BLOCK. See BIP 37 for more info.
  filterdBlock._internal(3),

  // Hash of a block header; identical to MSG_BLOCK. See BIP 152 for more info.
  compactBlock._internal(4),

  // Hash of a transaction with witness data. See BIP 144 for more info.
  witnessTransaction._internal(0x40000001),

  // Hash of a block with witness data. See BIP 144 for more info.
  witnessBlock._internal(0x40000002),

  // Hash of a block with witness data. See BIP 144 for more info.
  filterdWitnessBlock._internal(0x40000003);

  factory InventoryType.deserialize(Uint8List bytes) {
    if (bytes.length != bytesLength()) {
      throw ArgumentError('''
The length of given bytes is invalid
Expected: ${bytesLength()}, Actual: ${bytes.length}''');
    }

    final value = CreateInt.fromUint32leBytes(bytes);

    switch (value) {
      case 0:
        return InventoryType.error;

      case 1:
        return InventoryType.transaction;

      case 2:
        return InventoryType.block;

      case 3:
        return InventoryType.filterdBlock;

      case 4:
        return InventoryType.compactBlock;

      case 0x40000001:
        return InventoryType.witnessTransaction;

      case 0x40000002:
        return InventoryType.witnessBlock;

      case 0x40000003:
        return InventoryType.filterdWitnessBlock;
    }

    throw ArgumentError('"$value" is undefined InventoryType value');
  }

  const InventoryType._internal(this.value);

  static int bytesLength() => 4;

  final int value;

  Map<String, dynamic> toJson() => {'value': '${toString()}($value)'};

  Uint8List serialize() => value.toUint32leBytes();
}
