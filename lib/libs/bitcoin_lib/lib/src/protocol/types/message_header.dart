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

  factory MessageHeader.deserialize(Uint8List bytes, Uint8List payload) {
    if (bytes.length != bytesLength()) {
      throw ArgumentError('the length of given bytes is invalid');
    }

    final magic = Magic.deserialize(
      bytes.sublist(
        0,
        Magic.bytesLength(),
      ),
    );
    final command = Command.deserialize(
      bytes.sublist(
        Magic.bytesLength(),
        Magic.bytesLength() + Command.bytesLength(),
      ),
    );
    final payloadLength = PayloadLength.deserialize(
      bytes.sublist(
        Magic.bytesLength() + Command.bytesLength(),
        Magic.bytesLength() +
            Command.bytesLength() +
            PayloadLength.bytesLength(),
      ),
    );
    final checksumBytes = bytes.sublist(
      Magic.bytesLength() + Command.bytesLength() + PayloadLength.bytesLength(),
      Magic.bytesLength() +
          Command.bytesLength() +
          PayloadLength.bytesLength() +
          Checksum.bytesLength(),
    );

    final checksum = Checksum.fromPayload(payload);

    if (!checksum.isValid(checksumBytes)) {
      throw ArgumentError('Checksum is invalid');
    }

    return MessageHeader._internal(
      magic,
      command,
      payloadLength,
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

  static bool isValidChecksum(Uint8List checksum, Uint8List payload) {
    return Checksum.fromPayload(payload).isValid(checksum);
  }
}
