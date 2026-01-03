import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/sip_hash.dart';

import 'data/sip_hash_answers.dart';

void main() {
  group('create SipHash instance', () {
    test('with valid params', () {
      final key = Uint8List.fromList([for (var i = 0; i < 16; i++) i]);
      final dataList = <int>[];
      for (var i = 0; i < 64; i++) {
        if (i > 0) {
          dataList.add(i - 1);
        }
        final sipHash = SipHash(key: key, data: Uint8List.fromList(dataList));
        expect(sipHash, isA<SipHash>());
        expect(sipHash.bytes, Uint8List.fromList(siphash24Answers[i]));
      }
    });
  });
}
