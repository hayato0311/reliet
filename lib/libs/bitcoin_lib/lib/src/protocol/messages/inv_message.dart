import 'dart:typed_data';

import '../types/inventory.dart';
import '../types/variable_length_integer.dart';

class InvMessage {
  InvMessage(this.count, this.inventories);

  factory InvMessage.deserialize(Uint8List bytes) {
    final headByte = bytes[0];
    final varIntBytesLength = VarInt.bytesLength(headByte);

    if (bytes.length < varIntBytesLength) {
      throw ArgumentError('The length of given bytes is invalid');
    }

    final count = VarInt.deserialize(bytes.sublist(0, varIntBytesLength));

    var startIndex = varIntBytesLength;

    final inventories = <Inventory>[];

    for (var i = 0; i < count.value; i++) {
      inventories.add(
        Inventory.deserialize(
          bytes.sublist(
            startIndex,
            startIndex + Inventory.bytesLength(),
          ),
        ),
      );
      startIndex += Inventory.bytesLength();
    }

    if (bytes.length != startIndex) {
      throw ArgumentError('Given bytes is invalid');
    }

    return InvMessage(count, inventories);
  }

  static int bytesLength(VarInt count) => Inventory.bytesLength() * count.value;

  final VarInt count;
  final List<Inventory> inventories;

  Map<String, dynamic> toJson() => {
        'count': count.toJson(),
        'inventories': [for (var inventory in inventories) inventory.toJson()]
      };

  Uint8List serialize() {
    final byteList = <int>[
      ...count.serialize(),
      for (var inventory in inventories) ...inventory.serialize(),
    ];

    return Uint8List.fromList(byteList);
  }
}
