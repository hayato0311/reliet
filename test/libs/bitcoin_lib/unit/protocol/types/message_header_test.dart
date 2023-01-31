import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/checksum.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/command.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/magic.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/message_header.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/payload_length.dart';

void main() {
  group('create and serialize MessageHeader instance', () {
    test('with valid params', () {
      const magic = Magic.testnet;
      const command = Command.version;
      final payload = Uint8List.fromList([0x10, 0x10]);
      final checksum = Checksum.fromPayload(payload);
      final messageHeader = MessageHeader.create(
        magic: magic,
        command: command,
        payload: payload,
      );

      final serializedMessageHeader = <int>[
        ...magic.serialize(),
        ...command.serialize(),
        ...PayloadLength(payload.length).serialize(),
        ...checksum.serialize(),
      ];

      expect(
        messageHeader.serialize(),
        Uint8List.fromList(serializedMessageHeader),
      );
    });
  });
}