import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/service.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/services.dart';

void main() {
  group('create and serialize ServiceFlags instance', () {
    test('with single service', () {
      final serviceList = [ServiceFlag.nodeNetwork];
      final services = ServiceFlags(serviceList);

      expect(services.serviceList, serviceList);
      expect(
        services.serialize(),
        ServiceFlag.nodeNetwork.value.toUint64leBytes(),
      );
    });

    test('with multi service', () {
      final serviceList = [
        ServiceFlag.nodeNetwork,
        ServiceFlag.nodeGetutxo,
        ServiceFlag.nodeBloom,
        ServiceFlag.nodeWitness,
        ServiceFlag.nodeXthin,
        ServiceFlag.nodeCompactFilters,
        ServiceFlag.nodeNetworkLimited,
      ];
      final services = ServiceFlags(serviceList);

      final servicesValueSum = ServiceFlag.nodeNetwork.value +
          ServiceFlag.nodeGetutxo.value +
          ServiceFlag.nodeBloom.value +
          ServiceFlag.nodeWitness.value +
          ServiceFlag.nodeXthin.value +
          ServiceFlag.nodeCompactFilters.value +
          ServiceFlag.nodeNetworkLimited.value;

      expect(
        services.serviceList,
        serviceList,
      );
      expect(
        services.serialize(),
        servicesValueSum.toUint64leBytes(),
      );
    });
  });

  group('deserialize bytes to ServiceFlags instance', () {
    group('with valid bytes', () {
      test('when zero', () {
        final serviceList = [ServiceFlag.nodeZero];
        final serializedServicesBytes = ServiceFlags(serviceList).serialize();
        expect(
          ServiceFlags.deserialize(serializedServicesBytes).serviceList.toSet(),
          serviceList.toSet(),
        );
      });

      test('with all services bytes', () {
        final serviceList = [
          ServiceFlag.nodeNetwork,
          ServiceFlag.nodeGetutxo,
          ServiceFlag.nodeBloom,
          ServiceFlag.nodeWitness,
          ServiceFlag.nodeXthin,
          ServiceFlag.nodeCompactFilters,
          ServiceFlag.nodeNetworkLimited,
        ];
        final serializedServicesBytes = ServiceFlags(serviceList).serialize();
        expect(
          ServiceFlags.deserialize(serializedServicesBytes).serviceList.toSet(),
          serviceList.toSet(),
        );
      });
    });
    group('with invalid bytes', () {
      test('when empty bytes', () {
        expect(
          () => ServiceFlags.deserialize(Uint8List.fromList([])).serviceList,
          throwsArgumentError,
        );
      });
      test('when not defind service value is included', () {
        expect(
          () => ServiceFlags.deserialize(Uint8List.fromList([40])).serviceList,
          throwsArgumentError,
        );
      });
    });
  });
}
