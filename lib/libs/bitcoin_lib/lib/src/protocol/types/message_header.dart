import 'dart:typed_data';

import '../../encode.dart';
import 'magic.dart';

class MessageHeader {
  final int magic;
  final String command;
  final int length;
  final List<int> checksum;

  MessageHeader({
    required this.magic,
    required this.command,
    required this.length,
    required this.checksum,
  });

  static MessageHeader create(String command, Uint8List payload,
      {bool testnet = false}) {
    int magic = testnet ? Magic.testnet : Magic.main;

    return MessageHeader(
      magic: magic,
      command: command,
      length: payload.length,
      checksum: payloadToChecksum(payload),
    );
  }

  Uint8List serialize() {
    if (checksum.length != 4) {
      print(checksum);
      throw Exception("checksum must be 4 bytes data");
    }

    List<int> byteList = [
      ...uint32leBytes(magic).toList(),
      ...stringleBytes(command, 12).toList(),
      ...uint32leBytes(length).toList(),
      ...Uint8List.fromList(checksum),
    ];

    return Uint8List.fromList(byteList);
  }
}
