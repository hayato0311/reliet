import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/timestamp.dart';

void main() {
  group('create and serialize StartHeight instance', () {
    test('with vaild value', () {
      final timestamp = Timestamp(0x7fffffffffffffff);
      expect(timestamp.unixtime, 0x7fffffffffffffff);
      expect(
        timestamp.serialize(),
        Uint8List.fromList([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x7f]),
      );
    });
  });
}
