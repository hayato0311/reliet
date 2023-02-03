import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/service.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/services.dart';

void main() {
  group('create and serialize Services instance', () {
    test('with single service', () {
      final serviceList = [Service.nodeNetwork];
      final services = Services(serviceList);

      expect(services.serviceList, serviceList);
      expect(
        services.serialize(),
        Service.nodeNetwork.value.toUint64leBytes(),
      );
    });

    test('with multi service', () {
      final serviceList = [
        Service.nodeNetwork,
        Service.nodeGetutxo,
        Service.nodeBloom,
        Service.nodeWitness,
        Service.nodeXthin,
        Service.nodeCompactFilters,
        Service.nodeNetworkLimited,
      ];
      final services = Services(serviceList);

      final servicesValueSum = Service.nodeNetwork.value +
          Service.nodeGetutxo.value +
          Service.nodeBloom.value +
          Service.nodeWitness.value +
          Service.nodeXthin.value +
          Service.nodeCompactFilters.value +
          Service.nodeNetworkLimited.value;

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

  group('deserialize bytes to Port instance', () {
    group('with valid bytes', () {
      test('with all services bytes', () {
        final serviceList = [
          Service.nodeNetwork,
          Service.nodeGetutxo,
          Service.nodeBloom,
          Service.nodeWitness,
          Service.nodeXthin,
          Service.nodeCompactFilters,
          Service.nodeNetworkLimited,
        ];
        final serializedServicesBytes = Services(serviceList).serialize();
        expect(
          Services.deserialize(serializedServicesBytes).serviceList.toSet(),
          serviceList.toSet(),
        );
      });
    });
    group('with invalid bytes', () {
      test('with empty bytes', () {
        expect(
          () => Services.deserialize(Uint8List.fromList([])).serviceList,
          throwsArgumentError,
        );
      });
    });
  });
}
