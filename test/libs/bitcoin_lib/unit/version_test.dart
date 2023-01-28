import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/version.dart';

void main() {
  group('create and serialize Version instance', () {
    test('for protocolVersion', () {
      const Version version = Version.protocolVersion;

      expect(version.value, 70015);
      expect(version.serialize(), Uint8List.fromList([127, 17, 1, 0]));
    });
  });
}
