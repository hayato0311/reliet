import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/spv_client.dart';

void main() {
  // TODO: refactor to use mockito
  test('send ping, then recieve pong', () async {
    final spvClient =
        SpvClient(nodeHost: '2406:da12:ce1:f001:1312:e40f:3d0f:2ebe');

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
