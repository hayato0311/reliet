import 'dart:typed_data';

import '../../encode.dart';

class NetAddr {
  final int services;
  final List<int> ipbe;
  final int port;

  NetAddr({
    required this.services,
    required this.ipbe,
    required this.port,
  });

  Uint8List serialize() {
    if (ipbe.length != 16) {
      throw Exception(
          "ipbe must be 16 bytes IPv6 address or IPv4-mapped IPv6 address");
    }

    List<int> byteList = [
      ...uint64leBytes(services).toList(),
      ...Uint8List.fromList(ipbe).toList(),
      ...uint16beBytes(port).toList(),
    ];

    return Uint8List.fromList(byteList);
  }
}
