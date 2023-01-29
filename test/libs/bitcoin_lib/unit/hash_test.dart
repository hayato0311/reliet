import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/utils/hash.dart';

void main() {
  test('generate hash256 value', () {
    final input = <int>[113, 17, 1, 0];

    final ans = <int>[
      170,
      129,
      213,
      95,
      248,
      250,
      162,
      214,
      61,
      190,
      12,
      174,
      122,
      158,
      23,
      120,
      93,
      69,
      9,
      186,
      106,
      208,
      210,
      245,
      173,
      201,
      29,
      105,
      76,
      115,
      255,
      114
    ];

    expect(hash256(input).bytes, ans);
  });
}
