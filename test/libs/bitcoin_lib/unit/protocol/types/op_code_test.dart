import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/op_code.dart';

void main() {
  group('create and serialize OpCode instance', () {
    test('with valid input', () {
      expect(OpCode.opPushBytes1.value, 1);
      expect(OpCode.opPushBytes1.serialize(), Uint8List.fromList([1]));
    });
  });

  group('deserialize bytes to Nonce instance', () {
    test('with valid bytes', () {
      final serializedBytes = OpCode.opPushBytes1.serialize();

      expect(
        OpCode.deserialize(serializedBytes),
        OpCode.opPushBytes1,
      );
    });
    test('with invalid bytes', () {
      expect(
        () => OpCode.deserialize(Uint8List.fromList([0, 0, 0, 1])),
        throwsArgumentError,
      );
    });
  });
}
