import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/string_extensions.dart';

void main() {
  group('convert string into bytes', () {
    test('without specified length', () {
      expect('valid'.encodeAsUtf8(), utf8.encode('valid'));
    });
    test('with valid length', () {
      expect(
          'valid'.encodeAsUtf8(10), [...utf8.encode('valid'), 0, 0, 0, 0, 0]);
    });
    test('with invalid length', () {
      expect(() => 'invalid'.encodeAsUtf8(1), throwsArgumentError);
    });
  });

  group('convert bytes into string', () {
    test('with valid bytes', () {
      expect(
        CreateString.fromBytes(
          Uint8List.fromList([...utf8.encode('valid'), 0, 0, 0, 0, 0]),
        ),
        'valid',
      );
    });
  });
}
