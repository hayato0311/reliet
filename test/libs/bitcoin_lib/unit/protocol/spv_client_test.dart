import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/spv_client.dart';

void main() {
  test('send and receive version', () async {
    final spvClient = SpvClient();
    await spvClient.connectToNode();
    expect(
      spvClient.handshakeCompleted,
      isTrue,
    );
  });
}
