import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/bool_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/ip_address.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/network_address.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/nonce.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/port.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/service.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/services.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/start_height.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/timestamp.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_string.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/version.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/version_message.dart';

void main() {
  group('create and serialize Version instance', () {
    test('with valid args', () {
      const version = Version.protocolVersion;
      final services = Services([Service.nodeZero]);
      final ipAddr = IpAddr([0, 0, 0, 0]);
      final addrRecv = NetAddr(
        services: services,
        ipAddr: ipAddr,
        port: Port.zero,
      );
      final addrFrom = NetAddr(
        services: services,
        ipAddr: ipAddr,
        port: Port.zero,
      );
      final nonce = Nonce(<int>[0, 0, 0, 0, 0, 0, 0, 0]);
      final userAgent = VarStr('userAgentString');
      final startHeight = StartHeight(0);
      const relay = false;

      final unixtime = (DateTime.now().millisecondsSinceEpoch / 1000).floor();

      final versionMessage = VersionMessage.create(
        version: version,
        services: services,
        addrRecv: addrRecv,
        addrFrom: addrFrom,
        nonce: nonce,
        userAgent: userAgent,
        startHeight: startHeight,
        relay: relay,
      );
      expect(versionMessage.timestamp.unixtime, unixtime);

      final serializedVersionMessage = <int>[
        ...version.serialize(),
        ...services.serialize(),
        ...Timestamp(unixtime).serialize(),
        ...addrRecv.serialize(),
        ...addrFrom.serialize(),
        ...nonce.serialize(),
        ...userAgent.serialize(),
        ...startHeight.serialize(),
        relay.toInt(),
      ];

      expect(
        versionMessage.serialize(),
        Uint8List.fromList(serializedVersionMessage),
      );
    });
  });
}
