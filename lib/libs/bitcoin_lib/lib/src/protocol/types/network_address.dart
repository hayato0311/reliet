import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'ip_address.dart';
import 'port.dart';
import 'services.dart';

@immutable
class NetAddr {
  const NetAddr({
    required this.services,
    required this.ipAddr,
    required this.port,
  });

  factory NetAddr.deserialize(Uint8List bytes) {
    if (bytes.length != bytesLength()) {
      throw ArgumentError('the length of given bytes is invalid');
    }

    final services = Services.deserialize(
      bytes.sublist(
        0,
        Services.bytesLength(),
      ),
    );
    final ipAddr = IpAddr.deserialize(
      bytes.sublist(
        Services.bytesLength(),
        Services.bytesLength() + IpAddr.bytesLength(),
      ),
    );
    final port = Port.deserialize(
      bytes.sublist(
        Services.bytesLength() + IpAddr.bytesLength(),
        Services.bytesLength() + IpAddr.bytesLength() + Port.bytesLength(),
      ),
    );

    return NetAddr(services: services, ipAddr: ipAddr, port: port);
  }

  static int bytesLength() =>
      Services.bytesLength() + IpAddr.bytesLength() + Port.bytesLength();

  final Services services;
  final IpAddr ipAddr;
  final Port port;

  Map<String, dynamic> toJson() => {
        'services': services.toJson(),
        'ipAddr': ipAddr.toJson(),
        'port': port.toJson(),
      };

  Uint8List serialize() {
    final byteList = <int>[
      ...services.serialize(),
      ...ipAddr.serialize(),
      ...port.serialize(),
    ];

    return Uint8List.fromList(byteList);
  }
}
