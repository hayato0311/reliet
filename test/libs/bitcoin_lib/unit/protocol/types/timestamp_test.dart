import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/timestamp.dart';

void main() {
  group('create and serialize StartHeight instance', () {
    test('with a vaild value', () {
      final secondsUnixtime =
          (DateTime.now().millisecondsSinceEpoch / 1000).floor();
      final timestamp = Timestamp.create();

      expect(timestamp.secondsUnixtime, secondsUnixtime);
      expect(
        timestamp.serialize(),
        secondsUnixtime.toInt64leBytes(),
      );
    });
  });

  group('deserialize bytes to StartHeight instance', () {
    test('with valid bytes', () {
      final secondsUnixtime =
          (DateTime.now().millisecondsSinceEpoch / 1000).floor();
      final serializedUnixtimeBytes = Timestamp.create().serialize();

      expect(
        Timestamp.deserialize(serializedUnixtimeBytes).secondsUnixtime,
        secondsUnixtime,
      );
    });

    test('with invalid bytes', () {
      expect(
        () => Timestamp.deserialize(
          Uint8List.fromList([0, 0, 0, 1]),
        ),
        throwsArgumentError,
      );
    });
  });
}
