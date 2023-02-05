import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/magic.dart';

void main() {
  group('create and serialize Magic instance', () {
    test('for testnet', () {
      const magic = Magic.testnet;

      expect(magic.value, 0x0709110b);

      expect(magic.serialize(), Uint8List.fromList([0x0b, 0x11, 0x09, 0x07]));
    });
    test('for mainnet', () {
      const magic = Magic.mainnet;

      expect(magic.value, 0xd9b4bef9);
      expect(magic.serialize(), Uint8List.fromList([0xf9, 0xbe, 0xb4, 0xd9]));
    });
  });

  group('deserialize bytes to Magic instance', () {
    test('for testnet', () {
      final testnetMagicBytes = Magic.testnet.serialize();

      expect(Magic.deserialize(testnetMagicBytes), Magic.testnet);
    });
    test('for mainnet', () {
      final mainnetMagicBytes = Magic.mainnet.serialize();

      expect(Magic.deserialize(mainnetMagicBytes), Magic.mainnet);
    });
    test('with invalid bytes', () {
      final bytes = Uint8List.fromList(utf8.encode('invalid'));

      expect(() => Magic.deserialize(bytes), throwsArgumentError);
    });
  });
}
