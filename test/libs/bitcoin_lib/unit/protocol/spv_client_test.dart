import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/spv_client.dart';

void main() {
  // TODO: refactor to use mockito
  test('connect to a Node by handshake', () async {
    final spvClient = SpvClient();
    await spvClient.connectToNode();
    expect(
      spvClient.handshakeCompleted,
      isTrue,
    );
  });

  test('send ping, then recieve pong', () async {
    final spvClient = SpvClient();

    await spvClient.connectToNode();
    expect(
      spvClient.pongMessageRecieved,
      isFalse,
    );

    await spvClient.sendPing();
    expect(
      spvClient.pongMessageRecieved,
      isTrue,
    );
  });
}
