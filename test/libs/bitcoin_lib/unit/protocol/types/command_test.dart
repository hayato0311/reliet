import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/string_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/command.dart';

void main() {
  group('create and serialize Command instance', () {
    test('of version', () {
      const command = Command.version;

      expect(command.value, 'version');

      final actualSerializedCommand = command.serialize();

      expect(
        actualSerializedCommand,
        'version'.toBytes(12),
      );

      expect(
        actualSerializedCommand.length,
        12,
      );
    });
  });

  group('deserialize bytes to Command instance', () {
    test('of version', () {
      final versionCommandBytes = Command.version.serialize();
      final deserializedCommand = Command.deserialize(versionCommandBytes);

      expect(deserializedCommand.value, 'version');
    });

    test('with invalid bytes', () {
      final bytes = Uint8List.fromList(utf8.encode('invalid'));

      expect(() => Command.deserialize(bytes), throwsArgumentError);
    });
  });
}
