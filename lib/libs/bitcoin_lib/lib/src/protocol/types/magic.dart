import 'dart:typed_data';

import '../../extensions/int_extensions.dart';

enum Magic {
  mainnet(0xd9b4bef9),
  testnet(0x0709110b);

  const Magic(this.value);
  final int value;

  Uint8List serialize() => value.toUint32leBytes();
}
