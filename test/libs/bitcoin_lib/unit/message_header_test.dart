import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/checksum.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/command.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/magic.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/message_header.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/payload_length.dart';

void main() {
  group('create and serialize MessageHeader instance', () {
    test('for testnet', () {
      const magic = Magic.testnet;
      const command = Command.version;
      final payload = Uint8List.fromList([0x10, 0x10]);
      final checksum = Checksum.fromPayload(payload);
      final messageHeader = MessageHeader.create(
        magic: magic,
        command: command,
        payload: payload,
      );

      final List<int> serializedMagic = magic.serialize();
      final List<int> serializedCommand = command.serialize();

      final List<int> serializedPayloadLength =
          PayloadLength(payload.length).serialize();
      final List<int> serializedChecksum = checksum.serialize();

      final serializedMessageHeader = <int>[
        ...serializedMagic,
        ...serializedCommand,
        ...serializedPayloadLength,
        ...serializedChecksum,
      ];

      expect(
        messageHeader.serialize(),
        Uint8List.fromList(serializedMessageHeader),
      );
    });
    test('for main', () {
      const magic = Magic.main;
      const command = Command.version;
      final payload = Uint8List.fromList([0x10, 0x10]);
      final checksum = Checksum.fromPayload(payload);
      final messageHeader = MessageHeader.create(
        magic: magic,
        command: command,
        payload: payload,
      );

      expect(messageHeader.magic, Magic.main);
      expect(messageHeader.command, command);
      expect(messageHeader.payloadLength.value, payload.length);
      expect(messageHeader.checksum.bytes, checksum.bytes);

      final List<int> serializedMagic = magic.serialize();
      final List<int> serializedCommand = command.serialize();
      final List<int> serializedPayloadLength =
          PayloadLength(payload.length).serialize();
      final List<int> serializedChecksum = checksum.serialize();

      final serializedMessageHeader = <int>[
        ...serializedMagic,
        ...serializedCommand,
        ...serializedPayloadLength,
        ...serializedChecksum,
      ];

      expect(
        messageHeader.serialize(),
        Uint8List.fromList(serializedMessageHeader),
      );
    });
  });
}
