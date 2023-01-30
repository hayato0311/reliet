import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/command.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/utils/encode.dart';

void main() {
  group('create and serialize Command instance', () {
    test('of version', () {
      const command = Command.version;

      expect(command.value, 'version');

      final actualSerializedCommand = command.serialize();

      expect(
        actualSerializedCommand,
        stringBytes('version', 12),
      );

      expect(
        actualSerializedCommand.length,
        12,
      );
    });
  });
}
