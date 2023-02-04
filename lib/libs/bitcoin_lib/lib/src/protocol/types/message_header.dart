import 'dart:typed_data';

import 'checksum.dart';
import 'command.dart';
import 'magic.dart';
import 'payload_length.dart';

class MessageHeader {
  factory MessageHeader.create({
    required Magic magic,
    required Command command,
    required Uint8List payload,
  }) {
    final checksum = Checksum.fromPayload(payload);

    return MessageHeader._internal(
      magic,
      command,
      PayloadLength(payload.length),
      checksum,
    );
  }

  MessageHeader._internal(
    this.magic,
    this.command,
    this.payloadLength,
    this.checksum,
  );

  static int bytesLength() =>
      Magic.bytesLength() +
      Command.bytesLength() +
      PayloadLength.bytesLength() +
      Checksum.bytesLength();

  final Magic magic;
  final Command command;
  final PayloadLength payloadLength;
  final Checksum checksum;

  Uint8List serialize() {
    final byteList = <int>[
      ...magic.serialize(),
      ...command.serialize(),
      ...payloadLength.serialize(),
      ...checksum.serialize(),
    ];

    return Uint8List.fromList(byteList);
  }
}
