import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/uint8_list_extensions.dart';

void main() {
  group('Uint8List to Hex', () {
    test('with prefix', () {
      final bytes = Uint8List.fromList([0x01, 0x0f]);
      expect(bytes.toHex(), '0x010f');
    });
    test('without prefix', () {
      final bytes = Uint8List.fromList([0x01, 0x0f]);
      expect(bytes.toHex(prefix: false), '010f');
    });
  });
}
