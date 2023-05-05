import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/string_extensions.dart';

void main() {
  group('encode string as utf8', () {
    test('without specified length', () {
      expect('valid'.encodeAsUtf8(), utf8.encode('valid'));
    });
    test('with valid length', () {
      expect(
        'valid'.encodeAsUtf8(10),
        [...utf8.encode('valid'), 0, 0, 0, 0, 0],
      );
    });
    test('with invalid length', () {
      expect(() => 'invalid'.encodeAsUtf8(1), throwsArgumentError);
    });
  });

  group('convert hex string to bytes', () {
    group('with valid string', () {
      test('when the string starts with 0x', () {
        expect('0xff01'.hexToBytes(), [255, 1]);
      });
      test('when the string does not start with 0x', () {
        expect('ff01'.hexToBytes(), [255, 1]);
      });
    });
    test('with invalid string', () {
      expect(() => 'zz01'.hexToBytes(), throwsFormatException);
    });
  });
}
