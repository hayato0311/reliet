import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/version.dart';

void main() {
  group('create and serialize Version instance', () {
    test('for protocolVersion', () {
      const version = Version.protocolVersion;
      const versionValue = 70015;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('for initProtoVersion', () {
      const version = Version.initProtoVersion;
      const versionValue = 209;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('for minPeerProtoVersion', () {
      const version = Version.minPeerProtoVersion;
      const versionValue = 31800;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('for bip0031Version', () {
      const version = Version.bip0031Version;
      const versionValue = 60000;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('for noBloomVersion', () {
      const version = Version.noBloomVersion;
      const versionValue = 70011;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('for sendHeadersVersion', () {
      const version = Version.sendHeadersVersion;
      const versionValue = 70012;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('for feeFilterVersion', () {
      const version = Version.feeFilterVersion;
      const versionValue = 70013;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('for shortIdsBlocksVersion', () {
      const version = Version.shortIdsBlocksVersion;
      const versionValue = 70014;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('for invalidCbNoBanVersion', () {
      const version = Version.invalidCbNoBanVersion;
      const versionValue = 70015;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });

    test('for wtxidRelayVersion', () {
      const version = Version.wtxidRelayVersion;
      const versionValue = 70016;

      expect(version.value, versionValue);
      expect(version.serialize(), versionValue.toInt32leBytes());
    });
  });
}
