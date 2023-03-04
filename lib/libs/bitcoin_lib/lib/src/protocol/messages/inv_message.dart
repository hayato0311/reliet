import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../types/inventory.dart';
import '../types/variable_length_integer.dart';

@immutable
class InvMessage {
  factory InvMessage(List<Inventory> inventories) {
    final count = VarInt(inventories.length);

    return InvMessage._internal(count, inventories);
  }

  const InvMessage._internal(this.count, this.inventories);

  factory InvMessage.deserialize(Uint8List bytes) {
    var startIndex = 0;

    final count = VarInt.deserialize(bytes.sublist(startIndex));
    startIndex += count.bytesLength();

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

    return InvMessage(inventories);
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
