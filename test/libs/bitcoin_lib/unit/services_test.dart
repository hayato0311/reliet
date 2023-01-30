import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/service.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/services.dart';

void main() {
  group('create and serialize Services instance', () {
    test('with single service', () {
      final services = Services([Service.nodeNetwork]);

      expect(services.value, 1);
      expect(
        services.serialize(),
        Uint8List.fromList([1, 0, 0, 0, 0, 0, 0, 0]),
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

      expect(services.value, 1 + 2 + 4 + 8 + 16 + 64 + 1024);
      expect(
        services.serialize(),
        Uint8List.fromList([95, 4, 0, 0, 0, 0, 0, 0]),
      );
    });
  });
}
