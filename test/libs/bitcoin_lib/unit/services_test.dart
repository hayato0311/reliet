import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/service.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/services.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/utils/encode.dart';

void main() {
  group('create and serialize Services instance', () {
    test('with single service', () {
      final services = Services([Service.nodeNetwork]);

      expect(services.value, Service.nodeNetwork.value);
      expect(
        services.serialize(),
        uint64leBytes(Service.nodeNetwork.value),
      );
    });

    test('with multi service', () {
      final services = Services([
        Service.nodeNetwork,
        Service.nodeGetutxo,
        Service.nodeBloom,
        Service.nodeWitness,
        Service.nodeXthin,
        Service.nodeCompactFilters,
        Service.nodeNetworkLimited,
      ]);

      final servicesValueSum = Service.nodeNetwork.value +
          Service.nodeGetutxo.value +
          Service.nodeBloom.value +
          Service.nodeWitness.value +
          Service.nodeXthin.value +
          Service.nodeCompactFilters.value +
          Service.nodeNetworkLimited.value;

      expect(
        services.value,
        servicesValueSum,
      );
      expect(
        services.serialize(),
        uint64leBytes(servicesValueSum),
      );
    });
  });
}
