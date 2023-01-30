import 'dart:developer' as developer;
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
    testnet ? Port.testnet.value : Port.main.value,
  );

  developer.log(
    'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}',
  );

  var result = 'failed to connect to node';

  // listen for responses from the server
  socket.listen(
    // handle data from the server
    (data) {
      developer.log('Server: Successfully received version');
      developer.log('$data');
      result = 'Successfully received version, but handshake not completed';
    },

    // handle errors
    onError: (error) {
      developer.log('$error');
      socket.destroy();
    },

    // handle server ending connection
    onDone: () {
      developer.log('Server left.');
      socket.destroy();
    },
  );

  // create payload and header

  final addrRecv = NetAddr(
    services: Services([Service.nodeZero]),
    ipAddr: IpAddr([0, 0, 0, 0]),
    port: testnet ? Port.testnet : Port.main,
  );

  const userAgentString = 'rust-example';
  final userAgent = VarStr(userAgentString);

  final services = Services([Service.nodeZero]);

  final addrFrom = NetAddr(
    services: services,
    ipAddr: IpAddr([0, 0, 0, 0]),
    port: Port.zero,
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
  ).serialize();

  const command = Command.version;
  final magic = testnet ? Magic.testnet : Magic.mainnet;

  final header = MessageHeader.create(
    magic: magic,
    command: command,
    payload: payload,
  ).serialize();

  // send

  await _sendMessage(socket, header, payload, command);

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
  developer.log('$message');
  developer.log('Send: ${command.value} ${payload.length}');
  await Future<void>.delayed(const Duration(seconds: 2));
}
