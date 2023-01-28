import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/checksum.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/command.dart';

import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/message_header.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/magic.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/payload_length.dart';

void main() {
  group('create and serialize MessageHeader instance', () {
    test('for testnet', () {
      Magic magic = Magic.testnet;
      Command command = Command.version;
      Uint8List payload = Uint8List.fromList([0x10, 0x10]);
      Checksum checksum = Checksum.fromPayload(payload);
      final MessageHeader messageHeader = MessageHeader.create(
        magic: magic,
        command: command,
        payload: payload,
      );

      List<int> serializedMagic = magic.serialize();
      List<int> serializedCommand = command.serialize();

      List<int> serializedPayloadLength =
          PayloadLength(payload.length).serialize();
      List<int> serializedChecksum = checksum.serialize();

      List<int> serializedMessageHeader = [
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
      Magic magic = Magic.main;
      Command command = Command.version;
      Uint8List payload = Uint8List.fromList([0x10, 0x10]);
      Checksum checksum = Checksum.fromPayload(payload);
      final MessageHeader messageHeader = MessageHeader.create(
        magic: magic,
        command: command,
        payload: payload,
      );

      expect(messageHeader.magic, Magic.main);
      expect(messageHeader.command, command);
      expect(messageHeader.payloadLength.value, payload.length);
      expect(messageHeader.checksum.bytes, checksum.bytes);

      List<int> serializedMagic = magic.serialize();
      List<int> serializedCommand = command.serialize();
      List<int> serializedPayloadLength =
          PayloadLength(payload.length).serialize();
      List<int> serializedChecksum = checksum.serialize();

      List<int> serializedMessageHeader = [
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
