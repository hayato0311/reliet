import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:riverpod/riverpod.dart';

import 'chain_params.dart';
import 'protocol/actions/send_message.dart';
import 'protocol/messages/block_message.dart';
import 'protocol/messages/inv_message.dart';
import 'protocol/messages/ping_message.dart';
import 'protocol/messages/pong_message.dart';
import 'protocol/messages/tx_message.dart';
import 'protocol/messages/version_message.dart';
import 'protocol/types/command.dart';
import 'protocol/types/hash256.dart';
import 'protocol/types/inventory.dart';
import 'protocol/types/inventory_type.dart';
import 'protocol/types/message_header.dart';
import 'protocol/types/port.dart';
import 'providers/inv_provider.dart';
import 'providers/ping_provider.dart';

class SpvClient {
  factory SpvClient({String nodeHost = '', bool testnet = false}) {
    return SpvClient._internal(nodeHost, testnet);
  }
  SpvClient._internal(this.nodeHost, this.testnet);

  final bool testnet;

  String nodeHost = 'not connecting';

  bool connecting = false;
  bool handshakeCompleted = false;
  bool pongMessageRecieved = false;

  BlockMessage? _blockMessage;
  TxMessage? _txMessage;

  Uint8List _buffer = Uint8List(0);

  final _container = ProviderContainer(
    observers: [
      PingObserver(),
      InvObserver(),
    ],
  );

  late Socket _socket;

  bool _versionReceived = false;

  Future<BlockMessage?> fetchBlock(Hash256 blockHash) async {
    if (!handshakeCompleted) {
      await _connectToNode();
    }

    _blockMessage = null;

    await sendGetDataMessage(
      _socket,
      [Inventory(InventoryType.block, blockHash)],
      testnet: testnet,
      verbose: true,
    );

    return _blockMessage;
  }

  Future<TxMessage?> fetchTx(Hash256 txHash) async {
    if (!handshakeCompleted) {
      await _connectToNode();
    }

    _txMessage = null;

    await sendGetDataMessage(
      _socket,
      [Inventory(InventoryType.transaction, txHash)],
      testnet: testnet,
      verbose: true,
    );

    return _txMessage;
  }

  Future<TxMessage?> fetchMerkleblock(Hash256 txHash) async {
    if (!handshakeCompleted) {
      await _connectToNode();
    }

    // _txMessage = null;

    // await sendFilterLoadMessage(
    //   _socket,
    //   [Inventory(InventoryType.transaction, txHash)],
    //   testnet: testnet,
    //   verbose: true,
    // );
    // await sendGetBlocksMessage(
    //   _socket,
    //   [Inventory(InventoryType.transaction, txHash)],
    //   testnet: testnet,
    //   verbose: true,
    // );

    return _txMessage;
  }

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
    if (connecting) return;

    final dnsSeeds = testnet ? TestnetParams.dnsSeeds : MainParams.dnsSeeds;

    if (nodeHost.isEmpty) {
      nodeHost = dnsSeeds[Random().nextInt(dnsSeeds.length)];
    }

    _socket = await Socket.connect(
      nodeHost,
      testnet ? Port.testnet : Port.mainnet,
    );

    print(
      'Connected to: ${_socket.remoteAddress.address}:${_socket.remotePort}',
    );
    connecting = true;
  }

  void disconnect() {
    if (!connecting) return;

    _socket.destroy();
    connecting = false;
    handshakeCompleted = false;
    pongMessageRecieved = false;
    _versionReceived = false;
  }

  void _listen({bool verbose = false}) {
    _socket.listen(
      (data) async {
        final MessageHeader messageHeader;
        data = Uint8List.fromList([..._buffer, ...data]);
        try {
          messageHeader = MessageHeader.deserialize(data);
        } on PacketsReceptionUnfinishedException catch (e) {
          if (verbose) print(e);
          _buffer = data;
          return;
        }
        _buffer = Uint8List(0);

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

            final pingObserverState =
                PingObserverState(_socket, pingMessage.nonce);
            _container
                .read(pingRecieverProvider.notifier)
                .updateState(pingObserverState);
            break;

          case Command.pong:
            pongMessageRecieved = true;

            if (verbose) {
              final pongMessage = PongMessage.deserialize(messageBytes);
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

          case Command.inv:
            final invMessage = InvMessage.deserialize(messageBytes);

            if (verbose) {
              print(
                jsonEncode({
                  messageHeader.command.string: {
                    'messageHeader': messageHeader.toJson(),
                    'message': invMessage.toJson()
                  },
                }),
              );
            }

            final invObserverState =
                InvObserverState(_socket, invMessage.inventories);
            _container
                .read(invRecieverProvider.notifier)
                .updateState(invObserverState);
            break;

          case Command.tx:
            _txMessage = TxMessage.deserialize(messageBytes);

            if (verbose) {
              print(
                jsonEncode({
                  messageHeader.command.string: {
                    'messageHeader': messageHeader.toJson(),
                    'message': _txMessage?.toJson()
                  },
                }),
              );
            }
            break;

          case Command.block:
            _blockMessage = BlockMessage.deserialize(messageBytes);

            if (verbose) {
              print(
                jsonEncode({
                  messageHeader.command.string: {
                    'messageHeader': messageHeader.toJson(),
                    'message': _blockMessage?.toJson()
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
