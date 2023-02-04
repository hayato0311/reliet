import 'dart:typed_data';

import '../../extensions/int_extensions.dart';

enum Port {
  mainnet(8333),
  testnet(18333),
  zero(0);

  const Port(this.value);

  factory Port.deserialize(Uint8List bytes) {
    final portValue = CreateInt.fromUint16beBytes(bytes);

    if (portValue == 8333) {
      return Port.mainnet;
    } else if (portValue == 18333) {
      return Port.testnet;
    } else if (portValue == 0) {
      return Port.zero;
    } else {
      throw ArgumentError('Undefined port value');
    }
  }

  static int bytesLength() => 2;

  final int value;

  Uint8List serialize() => value.toUint16beBytes();
}
