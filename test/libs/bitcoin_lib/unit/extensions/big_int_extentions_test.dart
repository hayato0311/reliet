import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/big_int_extensions.dart';

void main() {
  test('BigInt to Hex', () {
    final bigInt = BigInt.parse('0x010f');
    expect(bigInt.toHex(), '0x010f');
  });

  test('BigInt to Uint8List', () {
    final bigInt = BigInt.parse('0x010f');
    expect(bigInt.toUint8List(), Uint8List.fromList([0x01, 0x0f]));
  });
}
