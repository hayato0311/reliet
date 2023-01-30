import 'dart:typed_data';

import 'ip_address.dart';
import 'port.dart';
import 'services.dart';

class NetAddr {
  factory NetAddr({
    required Services services,
    required IpAddr ipAddr,
    required Port port,
  }) =>
      NetAddr._internal(services, ipAddr, port);

  const NetAddr._internal(this.services, this.ipAddr, this.port);
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
