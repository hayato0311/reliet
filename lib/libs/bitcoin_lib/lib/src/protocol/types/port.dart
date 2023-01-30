import 'dart:typed_data';

import '../../utils/encode.dart';

enum Port {
  main(8333),
  testnet(18333),
  zero(0);

  const Port(this.value);

  final int value;

  Uint8List serialize() => uint16beBytes(value);
}
