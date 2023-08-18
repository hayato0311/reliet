import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/uint8_list_extensions.dart';

void main() {
  test('Uint8List to Hex', () {
    final bytes = Uint8List.fromList([0x01, 0x0f]);
    expect(bytes.toHex(), '0x010f');
  });
}
