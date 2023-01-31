import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/ip_address.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/network_address.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/port.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/service.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/services.dart';

void main() {
  group('serialize network address', () {
    test('with valid params', () {
      final services = Services([Service.nodeNetwork]);
      final ipAddr =
          IpAddr([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 127, 0, 0, 1]);
      const port = Port.testnet;
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
}
