import 'dart:typed_data';

import '../../encode.dart';

enum Port {
  main(8333),
  testnet(18333),
  zero(0);

  final int value;
  const Port(this.value);

  Uint8List serialize() => uint16beBytes(value);
}
