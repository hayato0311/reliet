import 'dart:typed_data';

import 'checksum.dart';
import 'magic.dart';
import 'command.dart';
import 'payload_length.dart';

class MessageHeader {
  final Magic magic;
  final Command command;
  final PayloadLength payloadLength;
  final Checksum checksum;

  MessageHeader._internal(
    this.magic,
    this.command,
    this.payloadLength,
    this.checksum,
  );

  factory MessageHeader.create({
    required Magic magic,
    required Command command,
    required Uint8List payload,
  }) {
    final Checksum checksum = Checksum.fromPayload(payload);

    return MessageHeader._internal(
      magic,
      command,
      PayloadLength(payload.length),
      checksum,
    );
  }

  Uint8List serialize() {
    List<int> byteList = [
      ...magic.serialize(),
      ...command.serialize(),
      ...payloadLength.serialize(),
      ...checksum.serialize(),
    ];

    return Uint8List.fromList(byteList);
  }
}
