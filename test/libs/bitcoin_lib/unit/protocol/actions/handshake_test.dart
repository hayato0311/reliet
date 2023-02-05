import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/actions/handshake.dart';

void main() {
  test('send and receive version', () async {
    expect(
      await handshake(testnet: true),
      'handshake completed',
    );
  });
}
