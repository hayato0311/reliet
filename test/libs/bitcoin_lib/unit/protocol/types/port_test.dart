import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/port.dart';

void main() {
  group('create and serialize Port instance', () {
    test('for mainnet', () {
      final port = Port(Port.mainnet);
      expect(port.value, 8333);
      expect(port.serialize(), 8333.toUint16beBytes());
    });
    test('for testnet', () {
      final port = Port(Port.testnet);

      expect(port.value, 18333);
      expect(port.serialize(), 18333.toUint16beBytes());
    });
    test('for zero', () {
      final port = Port(Port.zero);

      expect(port.value, 0);
      expect(port.serialize(), 0.toUint16beBytes());
    });
  });

  group('deserialize bytes to Port instance', () {
    test('with valid value', () {
      const customPort = 52475;
      final serializedCustomPort = customPort.toUint16beBytes();
      expect(Port.deserialize(serializedCustomPort).value, customPort);
    });
    test('with invalid value', () {
      expect(
        () => Port.deserialize(Uint8List.fromList([0xff, 0xff, 0xff, 0xff])),
        throwsArgumentError,
      );
    });
  });
}
