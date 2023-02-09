import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'chain_params.dart';
import 'protocol/actions/send_message.dart';
import 'protocol/messages/ping_message.dart';
import 'protocol/messages/pong_message.dart';
import 'protocol/messages/version_message.dart';
import 'protocol/types/command.dart';
import 'protocol/types/message_header.dart';
import 'protocol/types/port.dart';

class SpvClient {
  factory SpvClient({bool testnet = false}) {
    return SpvClient._internal(testnet);
  }
  SpvClient._internal(this.testnet);

  final bool testnet;

  bool connecting = false;

  String nodeHost = 'not connecting';

  bool handshakeCompleted = false;
  bool pongMessageRecieved = false;

  late Socket _socket;

  bool _versionReceived = false;

  Future<void> sendPing() async {
    if (!handshakeCompleted) {
      await _connectToNode();
    }
    pongMessageRecieved = false;
    await sendPingMessage(_socket);
  }

  Future<void> _connectToNode() async {
    while (!handshakeCompleted) {
      if (connecting) {
        _socket.destroy();
      }

      await _connect();
      _listen();
      await _handshake();
    }
  }

  Future<void> _handshake() async {
    await sendVersionMessage(
      _socket,
      testnet: testnet,
    );

    if (!_versionReceived) return;

    await sendVerackMessage(
      _socket,
      testnet: testnet,
    );
  }

  Future<void> _connect() async {
    final dnsSeeds = testnet ? TestnetParams.dnsSeeds : MainParams.dnsSeeds;

    nodeHost = dnsSeeds[Random().nextInt(dnsSeeds.length)];

    _socket = await Socket.connect(
      nodeHost,
      testnet ? Port.testnet : Port.mainnet,
    );

    print(
      'Connected to: ${_socket.remoteAddress.address}:${_socket.remotePort}',
    );
    connecting = true;
  }

  void _listen({bool verbose = false}) {
    _socket.listen(
      (data) async {
        final messageHeader = MessageHeader.deserialize(data);
        final messageBytes = data.sublist(
          MessageHeader.bytesLength(),
          MessageHeader.bytesLength() + messageHeader.payloadLength.value,
        );

        print('Recv: ${messageHeader.command.string}');

        switch (messageHeader.command) {
          case Command.version:
            _versionReceived = true;

            if (verbose) {
              final versionMessage = VersionMessage.deserialize(messageBytes);
              print(
                jsonEncode({
                  messageHeader.command.string: {
                    'messageHeader': messageHeader.toJson(),
                    'message': versionMessage.toJson()
                  },
                }),
              );
            }

            break;

          case Command.verack:
            handshakeCompleted = true;
            break;

          case Command.sendheaders:
            handshakeCompleted = true;
            break;

          case Command.sendcmpct:
            handshakeCompleted = true;
            break;

          case Command.ping:
            final pingMessage = PingMessage.deserialize(messageBytes);

            if (verbose) {
              print(
                jsonEncode({
                  messageHeader.command.string: {
                    'messageHeader': messageHeader.toJson(),
                    'message': pingMessage.toJson()
                  },
                }),
              );
            }
            break;

          case Command.pong:
            pongMessageRecieved = true;
            final pongMessage = PongMessage.deserialize(messageBytes);

            if (verbose) {
              print(
                jsonEncode({
                  messageHeader.command.string: {
                    'messageHeader': messageHeader.toJson(),
                    'message': pongMessage.toJson()
                  },
                }),
              );
            }
            break;

          default:
            print('${messageHeader.command} is not supported yet');
        }
      },

      // handle errors
      onError: (error) {
        print('$error');
        _socket.destroy();
        connecting = false;
      },

      // handle server ending connection
      onDone: () {
        print('Server left.');
        _socket.destroy();
        connecting = false;
      },
    );
  }
}
