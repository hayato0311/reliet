import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/command.dart';

void main() {
  group('create and serialize Command instance', () {
    test('of version', () {
      const Command command = Command.version;

      expect(command.value, "version");
      expect(command.serialize(),
          Uint8List.fromList([...utf8.encode("version"), 0, 0, 0, 0, 0]));
    });
  });
}
