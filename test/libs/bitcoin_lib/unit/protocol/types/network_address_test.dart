import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/ip_address.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/network_address.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/port.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/service.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/services.dart';

void main() {
  group('serialize NetAddr', () {
    test('with valid params', () {
      final services = Services(const [Service.nodeNetwork]);
      final ipAddr =
          IpAddr(const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 127, 0, 0, 1]);
      final port = Port(Port.testnet);
      final netAddr = NetAddr(
        services: services,
        ipAddr: ipAddr,
        port: port,
      );

      final byteList = <int>[
        ...services.serialize(),
        ...ipAddr.serialize(),
        ...port.serialize(),
      ];

      expect(netAddr.serialize(), Uint8List.fromList(byteList));
    });
  });
  group('deserialize bytes to NetAddr instance', () {
    test('with valid bytes', () {
      final services = Services(const [Service.nodeNetwork]);
      final ipAddr = IpAddr(const [127, 0, 0, 1]);
      final port = Port(Port.testnet);
      final netAddr = NetAddr(
        services: services,
        ipAddr: ipAddr,
        port: port,
      );
      final serializedNetAddr = netAddr.serialize();

      expect(NetAddr.deserialize(serializedNetAddr), isA<NetAddr>());
    });
    test('with invalid bytes', () {
      expect(
        () => NetAddr.deserialize(Uint8List.fromList([0, 0, 0, 1])),
        throwsArgumentError,
      );
    });
  });
}
