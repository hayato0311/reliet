import 'dart:typed_data';

import '../../extensions/int_extensions.dart';

enum Magic {
  mainnet(0xd9b4bef9),
  testnet(0x0709110b);

  const Magic(this.value);

  factory Magic.deserialize(Uint8List bytes) {
    final magicValue = CreateInt.fromUint32leBytes(bytes);

    if (magicValue == Magic.mainnet.value) {
      return Magic.mainnet;
    } else if (magicValue == Magic.testnet.value) {
      return Magic.testnet;
    } else {
      throw ArgumentError('Undefined magic value');
    }
  }

  final int value;

  Uint8List serialize() => value.toUint32leBytes();
}
