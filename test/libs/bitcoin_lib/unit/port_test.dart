import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/port.dart';

void main() {
  group('create and serialize Port instance', () {
    test('for zero', () {
      const Port port = Port.zero;

      expect(port.value, 0);
      expect(port.serialize(), Uint8List.fromList([0, 0]));
    });
    test('for testnet', () {
      const Port port = Port.testnet;

      expect(port.value, 18333);
      expect(port.serialize(), Uint8List.fromList([71, 157]));
    });

    test('for mainnet', () {
      const Port port = Port.main;

      expect(port.value, 8333);
      expect(port.serialize(), Uint8List.fromList([32, 141]));
    });
  });
}
