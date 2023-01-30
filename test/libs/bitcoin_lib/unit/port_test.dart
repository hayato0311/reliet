import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/port.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/utils/encode.dart';

void main() {
  group('create and serialize Port instance', () {
    test('for zero', () {
      const port = Port.zero;

      expect(port.value, 0);
      expect(port.serialize(), uint16beBytes(0));
    });
    test('for testnet', () {
      const port = Port.testnet;

      expect(port.value, 18333);
      expect(port.serialize(), uint16beBytes(18333));
    });

    test('for mainnet', () {
      const port = Port.main;

      expect(port.value, 8333);
      expect(port.serialize(), uint16beBytes(8333));
    });
  });
}
