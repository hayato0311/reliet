import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'chain_params.dart';
import 'protocol/actions/handshake.dart';
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
  String status = '';

  bool handshakeCompleted = false;

  late Socket _socket;

  String nodeHost = '';

  Future<void> connectToNode() async {
    while (!handshakeCompleted) {
      await _connect();
      _listen();
      await handshake(_socket);
    }
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
      // handle data from the server
      (data) async {
        final messageHeader = MessageHeader.deserialize(data);
        final messageBytes = data.sublist(
          MessageHeader.bytesLength(),
          MessageHeader.bytesLength() + messageHeader.payloadLength.value,
        );

        print('Recv: ${messageHeader.command.string}');

        switch (messageHeader.command) {
          case Command.version:
            final versionMessage = VersionMessage.deserialize(messageBytes);

            if (verbose) {
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

          default:
            print('${messageHeader.command} is not supported yet');
        }
      },

      // handle errors
      onError: (error) {
        print('$error');
        connecting = false;
        _socket.destroy();
      },

      // handle server ending connection
      onDone: () {
        print('Server left.');
        connecting = false;
        _socket.destroy();
      },
    );
  }
}
