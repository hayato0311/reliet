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
    test('create from .create factory constructor', () {
      final nonce = Nonce.create();

      expect(nonce, isA<Nonce>());
      expect(nonce.bytes.length, 8);
    });
  });

  group('deserialize bytes to Nonce instance', () {
    test('with valid bytes', () {
      final bytes = [0, 0, 0, 0, 0, 0, 0, 1];
      final serializedBytes = Nonce(bytes).serialize();

      expect(Nonce.deserialize(serializedBytes).bytes, bytes);
    });
    test('with invalid bytes', () {
      expect(
        () => Nonce.deserialize(Uint8List.fromList([0, 0, 0, 1])),
        throwsFormatException,
      );
    });
  });
}
