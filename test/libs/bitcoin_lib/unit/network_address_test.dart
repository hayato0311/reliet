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
      final netAddr = NetAddr(
        services: Services([Service.nodeNetwork]),
        ipAddr: IpAddr([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 127, 0, 0, 1]),
        port: Port.testnet,
      );

      final byteList = <int>[
        ...[1, 0, 0, 0, 0, 0, 0, 0],
        ...[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 127, 0, 0, 1],
        ...[71, 157],
      ];

      expect(netAddr.serialize(), Uint8List.fromList(byteList));
    });
  });
}
