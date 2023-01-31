import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/port.dart';

void main() {
  group('create and serialize Port instance', () {
    test('for zero', () {
      const port = Port.zero;

      expect(port.value, 0);
      expect(port.serialize(), 0.toUint16beBytes());
    });
    test('for testnet', () {
      const port = Port.testnet;

      expect(port.value, 18333);
      expect(port.serialize(), 18333.toUint16beBytes());
    });

    test('for mainnet', () {
      const port = Port.main;

      expect(port.value, 8333);
      expect(port.serialize(), 8333.toUint16beBytes());
    });
  });
}
