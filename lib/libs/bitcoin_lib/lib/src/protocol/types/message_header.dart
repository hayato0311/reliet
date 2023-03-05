import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'bases/uint32le.dart';
import 'checksum.dart';
import 'command.dart';
import 'magic.dart';

@immutable
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
      Uint32le(payload.length),
      checksum,
    );
  }

  factory MessageHeader.deserialize(Uint8List bytes) {
    var startIndex = 0;

    final magic = Magic.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Magic.bytesLength(),
      ),
    );
    startIndex += Magic.bytesLength();

    final command = Command.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Command.bytesLength(),
      ),
    );
    startIndex += Command.bytesLength();

    final payloadLength = Uint32le.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Uint32le.bytesLength(),
      ),
    );
    startIndex += Uint32le.bytesLength();

    final givenChecksum = bytes.sublist(
      startIndex,
      startIndex + Checksum.bytesLength(),
    );

    startIndex += Checksum.bytesLength();

    if (startIndex != bytesLength()) {
      throw ArgumentError('The length of given bytes is invalid');
    }

    final payload = bytes.sublist(startIndex, startIndex + payloadLength.value);

    final checksumFromPayload = Checksum.fromPayload(payload);

    if (!checksumFromPayload.isValid(givenChecksum)) {
      throw ArgumentError(
        'Given checksum and the checksum computed from payload are not equal.',
      );
    }

    return MessageHeader._internal(
      magic,
      command,
      payloadLength,
      checksumFromPayload,
    );
  }

  const MessageHeader._internal(
    this.magic,
    this.command,
    this.payloadLength,
    this.checksum,
  );

  static int bytesLength() =>
      Magic.bytesLength() +
      Command.bytesLength() +
      Uint32le.bytesLength() +
      Checksum.bytesLength();

  final Magic magic;
  final Command command;
  final Uint32le payloadLength;
  final Checksum checksum;

  Map<String, dynamic> toJson() => {
        'magic': magic.toJson(),
        'command': command.toJson(),
        'payloadLength': payloadLength.toJson(),
        'checksum': checksum.toJson(),
      };

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
