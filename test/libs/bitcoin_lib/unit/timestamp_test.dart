import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/timestamp.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/utils/encode.dart';

void main() {
  group('create and serialize StartHeight instance', () {
    test('with a vaild value', () {
      const unixtime = 0x7fffffffffffffff;
      final timestamp = Timestamp(unixtime);
      expect(timestamp.unixtime, unixtime);
      expect(
        timestamp.serialize(),
        int64leBytes(unixtime),
      );
    });
  });
}
