import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/version.dart';

void main() {
  group('create and serialize Version instance', () {
    test('of protocolVersion', () {
      const version = Version.protocolVersion;
      const versionValue = 70015;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('of initProtoVersion', () {
      const version = Version.initProtoVersion;
      const versionValue = 209;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('of minPeerProtoVersion', () {
      const version = Version.minPeerProtoVersion;
      const versionValue = 31800;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('of bip0031Version', () {
      const version = Version.bip0031Version;
      const versionValue = 60000;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('of noBloomVersion', () {
      const version = Version.noBloomVersion;
      const versionValue = 70011;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('of sendHeadersVersion', () {
      const version = Version.sendHeadersVersion;
      const versionValue = 70012;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('of feeFilterVersion', () {
      const version = Version.feeFilterVersion;
      const versionValue = 70013;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('of shortIdsBlocksVersion', () {
      const version = Version.shortIdsBlocksVersion;
      const versionValue = 70014;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('of invalidCbNoBanVersion', () {
      const version = Version.invalidCbNoBanVersion;
      const versionValue = 70015;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('of wtxidRelayVersion', () {
      const version = Version.wtxidRelayVersion;
      const versionValue = 70016;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });
  });
  group('deserialize bytes to Version instance', () {
    test('of initProtoVersion', () {
      final serializedVersionBytes = Version.initProtoVersion.serialize();

      expect(
        Version.deserialize(serializedVersionBytes),
        Version.initProtoVersion,
      );
    });

    test('of minPeerProtoVersion', () {
      final serializedVersionBytes = Version.minPeerProtoVersion.serialize();

      expect(
        Version.deserialize(serializedVersionBytes),
        Version.minPeerProtoVersion,
      );
    });
    test('of bip0031Version', () {
      final serializedVersionBytes = Version.bip0031Version.serialize();

      expect(
        Version.deserialize(serializedVersionBytes),
        Version.bip0031Version,
      );
    });
    test('of noBloomVersion', () {
      final serializedVersionBytes = Version.noBloomVersion.serialize();

      expect(
        Version.deserialize(serializedVersionBytes),
        Version.noBloomVersion,
      );
    });
    test('of sendHeadersVersion', () {
      final serializedVersionBytes = Version.sendHeadersVersion.serialize();

      expect(
        Version.deserialize(serializedVersionBytes),
        Version.sendHeadersVersion,
      );
    });
    test('of feeFilterVersion', () {
      final serializedVersionBytes = Version.feeFilterVersion.serialize();

      expect(
        Version.deserialize(serializedVersionBytes),
        Version.feeFilterVersion,
      );
    });
    test('of shortIdsBlocksVersion', () {
      final serializedVersionBytes = Version.shortIdsBlocksVersion.serialize();

      expect(
        Version.deserialize(serializedVersionBytes),
        Version.shortIdsBlocksVersion,
      );
    });
    test('of invalidCbNoBanVersion', () {
      final serializedVersionBytes = Version.invalidCbNoBanVersion.serialize();

      expect(
        Version.deserialize(serializedVersionBytes),
        Version.invalidCbNoBanVersion,
      );
    });
    test('of wtxidRelayVersion', () {
      final serializedVersionBytes = Version.wtxidRelayVersion.serialize();

      expect(
        Version.deserialize(serializedVersionBytes),
        Version.wtxidRelayVersion,
      );
    });

    test('with invalid bytes', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4]);

      expect(() => Version.deserialize(bytes), throwsArgumentError);
    });
  });
}
