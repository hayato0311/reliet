import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/ip_address.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/network_address.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/nonce.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/port.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/service.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/services.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/start_height.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_string.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/version.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/version_message.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/utils/encode.dart';

void main() {
  group('create and serialize Version instance', () {
    test('with valid args', () {
      final userAgent = VarStr('userAgentString');

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
      final startHeight = StartHeight(0);
      final unixtime = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
      final versionMessage = VersionMessage.create(
        version: Version.protocolVersion,
        services: services,
        addrRecv: addrRecv,
        addrFrom: addrFrom,
        nonce: Nonce(<int>[0, 0, 0, 0, 0, 0, 0, 0]),
        userAgent: userAgent,
        startHeight: StartHeight(0),
        relay: false,
      );
      expect(versionMessage.version, Version.protocolVersion);
      expect(versionMessage.services.value, services.value);
      expect(versionMessage.timestamp.unixtime, unixtime);
      expect(versionMessage.addrRecv.services.value, services.value);
      expect(
        versionMessage.addrRecv.ipAddr.bytes,
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 0, 0, 0, 0],
      );
      expect(versionMessage.addrRecv.port, Port.zero);

      expect(versionMessage.addrFrom.services.value, services.value);
      expect(
        versionMessage.addrFrom.ipAddr.bytes,
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 0, 0, 0, 0],
      );
      expect(versionMessage.addrFrom.port, Port.zero);

      expect(versionMessage.nonce.bytes, [0, 0, 0, 0, 0, 0, 0, 0]);
      expect(versionMessage.userAgent, userAgent);
      expect(versionMessage.startHeight.value, 0);
      expect(versionMessage.relay, false);

      final List<int> serializedVersion =
          int32leBytes(Version.protocolVersion.value);
      final serializedServices = <int>[0, 0, 0, 0, 0, 0, 0, 0];
      final List<int> serializedTimestamp = int64leBytes(unixtime);
      final List<int> serializedAddrRecv = addrRecv.serialize();
      final List<int> serializedAddrFrom = addrFrom.serialize();
      final List<int> serializedNonce = nonce.serialize();
      final List<int> serializedUserAgent = userAgent.serialize();
      final List<int> serializedStartHeight = startHeight.serialize();
      final serializedRelay = <int>[0];

      final serializedVersionMessage = <int>[
        ...serializedVersion,
        ...serializedServices,
        ...serializedTimestamp,
        ...serializedAddrRecv,
        ...serializedAddrFrom,
        ...serializedNonce,
        ...serializedUserAgent,
        ...serializedStartHeight,
        ...serializedRelay,
      ];

      expect(
        versionMessage.serialize(),
        Uint8List.fromList(serializedVersionMessage),
      );
    });
  });
}
