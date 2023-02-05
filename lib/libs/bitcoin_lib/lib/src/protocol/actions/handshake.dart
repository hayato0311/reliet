import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import '../../chain_params.dart';
import '../types/command.dart';
import '../types/ip_address.dart';
import '../types/magic.dart';
import '../types/message_header.dart';
import '../types/network_address.dart';
import '../types/nonce.dart';
import '../types/port.dart';
import '../types/service.dart';
import '../types/services.dart';
import '../types/start_height.dart';
import '../types/variable_length_string.dart';
import '../types/version.dart';
import '../types/version_message.dart';

Future<String> handshake({bool testnet = false}) async {
  // TODO: need refactoring

  final dnsSeeds = testnet ? TestnetParams.dnsSeeds : MainParams.dnsSeeds;

  final socket = await Socket.connect(
    dnsSeeds[Random().nextInt(dnsSeeds.length)],
    testnet ? Port.testnet : Port.mainnet,
  );

  print(
    'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}',
  );

  var result = 'failed to connect to node';

  var validVersionRecieved = false;

  // listen for responses from the server
  socket.listen(
    // handle data from the server
    (data) {
      print('Server: Successfully received version');
      print('$data');

      final messageHeader = MessageHeader.deserialize(data);

      if (messageHeader.command == Command.version) {
        validVersionRecieved = _receiveVersionMessage(
          messageHeader,
          data.sublist(
            MessageHeader.bytesLength(),
            MessageHeader.bytesLength() + messageHeader.payloadLength.value,
          ),
        );
      }
    },

    // handle errors
    onError: (error) {
      print('$error');
      socket.destroy();
    },

    // handle server ending connection
    onDone: () {
      print('Server left.');
      socket.destroy();
    },
  );

  await _sendVersionMessage(
    socket,
    testnet,
  );

  if (validVersionRecieved) {
    result = 'Successfully received version, but handshake does not completed';
  }

  return result;
}

Future<void> _sendMessage(
  Socket socket,
  Uint8List header,
  Uint8List payload,
  Command command,
) async {
  final message = Uint8List.fromList([...header, ...payload]);
  socket.add(message);
  print('$message');
  print('Send: $command ${payload.length}');
  await Future<void>.delayed(const Duration(seconds: 2));
}

Future<void> _sendVersionMessage(
  Socket socket,
  bool testnet,
) async {
  final addrRecv = NetAddr(
    services: Services([Service.nodeZero]),
    ipAddr: IpAddr([0, 0, 0, 0]),
    port: testnet ? Port(Port.testnet) : Port(Port.mainnet),
  );

  const userAgentString = 'rust-example';
  final userAgent = VarStr(userAgentString);

  final services = Services([Service.nodeZero]);

  final addrFrom = NetAddr(
    services: services,
    ipAddr: IpAddr([0, 0, 0, 0]),
    port: Port(Port.zero),
  );

  final payload = VersionMessage.create(
    version: Version.protocolVersion,
    services: services,
    addrRecv: addrRecv,
    addrFrom: addrFrom,
    nonce: Nonce([0, 0, 0, 0, 0, 0, 0, 0]),
    userAgent: userAgent,
    startHeight: StartHeight(0),
    relay: false,
  );

  final serializedPayload = payload.serialize();

  const command = Command.version;
  final magic = testnet ? Magic.testnet : Magic.mainnet;

  final header = MessageHeader.create(
    magic: magic,
    command: command,
    payload: serializedPayload,
  );

  print(
    jsonEncode({
      'Version': {
        'messageHeader': header.toJson(),
        'versionMessage': payload.toJson()
      },
    }),
  );

  await _sendMessage(socket, header.serialize(), serializedPayload, command);
}

bool _receiveVersionMessage(MessageHeader messageHeader, Uint8List payload) {
  final VersionMessage versionMessage;
  try {
    versionMessage = VersionMessage.deserialize(payload);
  } catch (e) {
    print(e);
    return false;
  }

  print(
    jsonEncode({
      'Version': {
        'messageHeader': messageHeader.toJson(),
        'versionMessage': versionMessage.toJson()
      },
    }),
  );

  return true;
}
