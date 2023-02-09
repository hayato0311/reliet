import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/spv_client.dart';

void main() {
  // TODO: refactor to use mockito
  test('send ping, then recieve pong', () async {
    final spvClient = SpvClient();

    expect(
      spvClient.pongMessageRecieved,
      isFalse,
    );

    await spvClient.sendPing();

    expect(
      spvClient.handshakeCompleted,
      isTrue,
    );

    expect(
      spvClient.pongMessageRecieved,
      isTrue,
    );
  });
}
