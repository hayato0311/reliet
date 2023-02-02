import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/port.dart';

void main() {
  group('create and serialize Port instance', () {
    test('for mainnet', () {
      const port = Port.mainnet;
      expect(port.value, 8333);
      expect(port.serialize(), 8333.toUint16beBytes());
    });
    test('for testnet', () {
      const port = Port.testnet;

      expect(port.value, 18333);
      expect(port.serialize(), 18333.toUint16beBytes());
    });
    test('for zero', () {
      const port = Port.zero;

      expect(port.value, 0);
      expect(port.serialize(), 0.toUint16beBytes());
    });
  });

  group('deserialize bytes to Port instance', () {
    test('of mainnet', () {
      final mainnetPortBytes = Port.mainnet.serialize();
      expect(Port.deserialize(mainnetPortBytes), Port.mainnet);
    });
    test('of testnet', () {
      final testnetPortBytes = Port.testnet.serialize();
      expect(Port.deserialize(testnetPortBytes), Port.testnet);
    });
    test('of zero', () {
      final zeroPortBytes = Port.zero.serialize();
      expect(Port.deserialize(zeroPortBytes), Port.zero);
    });
    test('with invalid bytes', () {
      expect(
        () => Port.deserialize(Uint8List.fromList([10, 10])),
        throwsArgumentError,
      );
    });
  });
}
