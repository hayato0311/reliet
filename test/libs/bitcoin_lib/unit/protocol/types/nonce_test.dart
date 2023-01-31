import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/nonce.dart';

void main() {
  group('create and serialize Nonce instance', () {
    test('with valid input', () {
      final nonce = Nonce([0, 0, 0, 0, 0, 0, 0, 1]);

      expect(nonce.bytes, [0, 0, 0, 0, 0, 0, 0, 1]);
      expect(nonce.serialize(), Uint8List.fromList([1, 0, 0, 0, 0, 0, 0, 0]));
    });
    test('with invalid input', () {
      expect(() => Nonce([0, 0, 0, 0, 0, 0, 0]), throwsFormatException);
      expect(() => Nonce([0, 0, 0, 0, 0, 0, 0, 0, 0]), throwsFormatException);
    });
  });
}
