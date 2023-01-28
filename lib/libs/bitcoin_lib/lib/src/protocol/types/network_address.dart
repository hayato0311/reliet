import 'dart:typed_data';

import 'port.dart';
import 'services.dart';
import 'ip_address.dart';

class NetAddr {
  final Services services;
  final IpAddr ipAddr;
  final Port port;

  const NetAddr._internal(this.services, this.ipAddr, this.port);

  factory NetAddr({
    required Services services,
    required IpAddr ipAddr,
    required Port port,
  }) =>
      NetAddr._internal(services, ipAddr, port);

  Uint8List serialize() {
    List<int> byteList = [
      ...services.serialize(),
      ...ipAddr.serialize(),
      ...port.serialize(),
    ];

    return Uint8List.fromList(byteList);
  }
}
