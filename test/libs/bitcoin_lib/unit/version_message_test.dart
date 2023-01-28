import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/ip_address.dart';

import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/version_message.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/port.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/variable_length_string.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/network_address.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/version.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/service.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/services.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/nonce.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/start_height.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/utils/encode.dart';

void main() {
  group('create and serialize Version instance', () {
    test('with valid args', () {
      VarStr userAgent = VarStr("userAgentString");

      final Services services = Services([Service.nodeZero]);
      final IpAddr ipAddr = IpAddr([0, 0, 0, 0]);
      final NetAddr addrRecv = NetAddr(
        services: services,
        ipAddr: ipAddr,
        port: Port.zero,
      );
      final NetAddr addrFrom = NetAddr(
        services: services,
        ipAddr: ipAddr,
        port: Port.zero,
      );
      final Nonce nonce = Nonce([0, 0, 0, 0, 0, 0, 0, 0]);
      final StartHeight startHeight = StartHeight(0);
      final int unixtime =
          (DateTime.now().millisecondsSinceEpoch / 1000).floor();
      final VersionMessage versionMessage = VersionMessage.create(
        version: Version.protocolVersion,
        services: services,
        addrRecv: addrRecv,
        addrFrom: addrFrom,
        nonce: Nonce([0, 0, 0, 0, 0, 0, 0, 0]),
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

      List<int> serializedVersion = int32leBytes(Version.protocolVersion.value);
      List<int> serializedServices = [0, 0, 0, 0, 0, 0, 0, 0];
      List<int> serializedTimestamp = int64leBytes(unixtime);
      List<int> serializedAddrRecv = addrRecv.serialize();
      List<int> serializedAddrFrom = addrFrom.serialize();
      List<int> serializedNonce = nonce.serialize();
      List<int> serializedUserAgent = userAgent.serialize();
      List<int> serializedStartHeight = startHeight.serialize();
      List<int> serializedRelay = [0];

      List<int> serializedVersionMessage = [
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
