import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/protocol_version.dart';

void main() {
  group('create and serialize ProtocolVersion instance', () {
    test('of defaultVersion', () {
      const version = ProtocolVersion.defaultVersion;
      const versionValue = 70015;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('of initProtoVersion', () {
      const version = ProtocolVersion.initProtoVersion;
      const versionValue = 209;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('of minPeerProtoVersion', () {
      const version = ProtocolVersion.minPeerProtoVersion;
      const versionValue = 31800;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('of bip0031Version', () {
      const version = ProtocolVersion.bip0031Version;
      const versionValue = 60000;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('of noBloomVersion', () {
      const version = ProtocolVersion.noBloomVersion;
      const versionValue = 70011;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('of sendHeadersVersion', () {
      const version = ProtocolVersion.sendHeadersVersion;
      const versionValue = 70012;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('of feeFilterVersion', () {
      const version = ProtocolVersion.feeFilterVersion;
      const versionValue = 70013;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('of shortIdsBlocksVersion', () {
      const version = ProtocolVersion.shortIdsBlocksVersion;
      const versionValue = 70014;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('of invalidCbNoBanVersion', () {
      const version = ProtocolVersion.invalidCbNoBanVersion;
      const versionValue = 70015;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('of wtxidRelayVersion', () {
      const version = ProtocolVersion.wtxidRelayVersion;
      const versionValue = 70016;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });
  });
  group('deserialize bytes to ProtocolVersion instance', () {
    test('of initProtoVersion', () {
      final serializedVersionBytes =
          ProtocolVersion.initProtoVersion.serialize();

      expect(
        ProtocolVersion.deserialize(serializedVersionBytes),
        ProtocolVersion.initProtoVersion,
      );
    });

    test('of minPeerProtoVersion', () {
      final serializedVersionBytes =
          ProtocolVersion.minPeerProtoVersion.serialize();

      expect(
        ProtocolVersion.deserialize(serializedVersionBytes),
        ProtocolVersion.minPeerProtoVersion,
      );
    });
    test('of bip0031Version', () {
      final serializedVersionBytes = ProtocolVersion.bip0031Version.serialize();

      expect(
        ProtocolVersion.deserialize(serializedVersionBytes),
        ProtocolVersion.bip0031Version,
      );
    });
    test('of noBloomVersion', () {
      final serializedVersionBytes = ProtocolVersion.noBloomVersion.serialize();

      expect(
        ProtocolVersion.deserialize(serializedVersionBytes),
        ProtocolVersion.noBloomVersion,
      );
    });
    test('of sendHeadersVersion', () {
      final serializedVersionBytes =
          ProtocolVersion.sendHeadersVersion.serialize();

      expect(
        ProtocolVersion.deserialize(serializedVersionBytes),
        ProtocolVersion.sendHeadersVersion,
      );
    });
    test('of feeFilterVersion', () {
      final serializedVersionBytes =
          ProtocolVersion.feeFilterVersion.serialize();

      expect(
        ProtocolVersion.deserialize(serializedVersionBytes),
        ProtocolVersion.feeFilterVersion,
      );
    });
    test('of shortIdsBlocksVersion', () {
      final serializedVersionBytes =
          ProtocolVersion.shortIdsBlocksVersion.serialize();

      expect(
        ProtocolVersion.deserialize(serializedVersionBytes),
        ProtocolVersion.shortIdsBlocksVersion,
      );
    });
    test('of invalidCbNoBanVersion', () {
      final serializedVersionBytes =
          ProtocolVersion.invalidCbNoBanVersion.serialize();

      expect(
        ProtocolVersion.deserialize(serializedVersionBytes),
        ProtocolVersion.invalidCbNoBanVersion,
      );
    });
    test('of wtxidRelayVersion', () {
      final serializedVersionBytes =
          ProtocolVersion.wtxidRelayVersion.serialize();

      expect(
        ProtocolVersion.deserialize(serializedVersionBytes),
        ProtocolVersion.wtxidRelayVersion,
      );
    });

    test('with invalid bytes', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4]);

      expect(() => ProtocolVersion.deserialize(bytes), throwsArgumentError);
    });
  });
}
