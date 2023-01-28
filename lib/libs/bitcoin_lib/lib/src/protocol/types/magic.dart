import 'dart:typed_data';

import '../../utils/encode.dart';

enum Magic {
  main(0xd9b4bef9),
  testnet(0x0709110b);

  final int value;

  const Magic(this.value);

  Uint8List serialize() => uint32leBytes(value);
}
