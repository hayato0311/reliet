import 'dart:typed_data';

import '../../extensions/int_extensions.dart';

enum Port {
  main(8333),
  testnet(18333),
  zero(0);

  const Port(this.value);

  final int value;

  Uint8List serialize() => value.toUint16beBytes();
}
