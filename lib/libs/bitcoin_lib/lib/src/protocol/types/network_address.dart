import 'dart:typed_data';

import 'ip_address.dart';
import 'port.dart';
import 'services.dart';

class NetAddr {
  NetAddr({
    required this.services,
    required this.ipAddr,
    required this.port,
  });

  static int bytesLength() =>
      Services.bytesLength() + IpAddr.bytesLength() + Port.bytesLength();

  final Services services;
  final IpAddr ipAddr;
  final Port port;

  Uint8List serialize() {
    final byteList = <int>[
      ...services.serialize(),
      ...ipAddr.serialize(),
      ...port.serialize(),
    ];

    return Uint8List.fromList(byteList);
  }
}
