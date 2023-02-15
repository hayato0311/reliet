import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../extensions/int_extensions.dart';

@immutable
class Port {
  factory Port(int value) {
    if (value != mainnet && value != testnet && value != zero) {
      throw ArgumentError(
        'Given port is invalid. Please set Port.mainnet, Port.testnet or Port.zero.',
      );
    }
    return Port._internal(value);
  }

  factory Port.deserialize(Uint8List bytes) {
    final value = CreateInt.fromUint16beBytes(bytes);
    return Port._internal(value);
  }

  const Port._internal(this.value);

  static int get mainnet => 8333;
  static int get testnet => 18333;
  static int get zero => 0;

  static int bytesLength() => 2;

  final int value;

  Map<String, dynamic> toJson() {
    final String portType;
    if (value == mainnet) {
      portType = 'mainnet';
    } else if (value == testnet) {
      portType = 'testnet';
    } else if (value == zero) {
      portType = 'zero';
    } else {
      portType = 'custom';
    }
    return {'value': '$value($portType)'};
  }

  Uint8List serialize() => value.toUint16beBytes();
}
