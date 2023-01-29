import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/ip_address.dart';

void main() {
  group('create and serialize Command instance', () {
    test('with IPv4 address', () {
      final ipAddr = IpAddr([127, 0, 0, 1]);
      expect(
        ipAddr.bytes,
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 127, 0, 0, 1],
      );
      expect(
        ipAddr.serialize(),
        Uint8List.fromList(
          [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 127, 0, 0, 1],
        ),
      );
    });
  });
}
