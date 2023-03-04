import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/int_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/lock_time.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/lock_time_type.dart';

void main() {
  group('create and serialize LockTime instance', () {
    test('which value is 0', () {
      const value = 0;
      final lockTime = LockTime(value);

      expect(lockTime.type, LockTimeType.notLocked);

      expect(lockTime.serialize(), value.toUint32leBytes());
    });

    test('which value is less than 500000000', () {
      const value = 499999999;
      final lockTime = LockTime(value);

      expect(lockTime.type, LockTimeType.blockNumber);

      expect(lockTime.serialize(), value.toUint32leBytes());
    });

    test('which value is 500000000 or more', () {
      const value = 500000000;
      final lockTime = LockTime(value);

      expect(lockTime.type, LockTimeType.secondsUnixtime);

      expect(lockTime.serialize(), value.toUint32leBytes());
    });
  });
  group('deserialize bytes to LockTime instance', () {
    test('which value is 0', () {
      const value = 0;
      final txVersion = LockTime(value);

      final serializedTxVersion = txVersion.serialize();

      final deserializedTxVersion = LockTime.deserialize(serializedTxVersion);

      expect(deserializedTxVersion, isA<LockTime>());
      expect(deserializedTxVersion.type, LockTimeType.notLocked);
    });

    test('which value is less than 500000000', () {
      const value = 499999999;
      final txVersion = LockTime(value);

      final serializedTxVersion = txVersion.serialize();

      final deserializedTxVersion = LockTime.deserialize(serializedTxVersion);

      expect(deserializedTxVersion, isA<LockTime>());
      expect(deserializedTxVersion.type, LockTimeType.blockNumber);
    });

    test('which value is 500000000 or more', () {
      const value = 500000000;
      final txVersion = LockTime(value);

      final serializedTxVersion = txVersion.serialize();

      final deserializedTxVersion = LockTime.deserialize(serializedTxVersion);

      expect(deserializedTxVersion, isA<LockTime>());
      expect(deserializedTxVersion.type, LockTimeType.secondsUnixtime);
    });
    test('with invalid bytes', () {
      expect(
        () => LockTime.deserialize(
          Uint8List.fromList([0, 0, 0, 0, 1]),
        ),
        throwsArgumentError,
      );
    });
  });
}
