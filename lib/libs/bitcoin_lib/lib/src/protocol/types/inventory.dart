import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'hash256.dart';
import 'inventory_type.dart';

@immutable
class Inventory {
  const Inventory(this.type, this.hash);

  factory Inventory.deserialize(Uint8List bytes) {
    var startIndex = 0;

    final type = InventoryType.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + InventoryType.bytesLength(),
      ),
    );
    startIndex += InventoryType.bytesLength();

    final hash = Hash256.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Hash256.bytesLength(),
      ),
    );

    startIndex += Hash256.bytesLength();

    if (bytes.length != startIndex) {
      throw ArgumentError('Given bytes is invalid');
    }

    return Inventory(type, hash);
  }

  static int bytesLength() =>
      InventoryType.bytesLength() + Hash256.bytesLength();

  final InventoryType type;
  final Hash256 hash;

  Map<String, dynamic> toJson() =>
      {'type': type.toJson(), 'hash': hash.toJson()};

  Uint8List serialize() {
    final byteList = <int>[
      ...type.serialize(),
      ...hash.serialize(),
    ];

    return Uint8List.fromList(byteList);
  }
}
