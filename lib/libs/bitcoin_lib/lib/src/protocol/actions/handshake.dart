import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../messages/version_message.dart';
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

Future<void> handshake(
  Socket socket, {
  bool testnet = false,
  bool verbose = false,
}) async {
  await _sendVersionMessage(
    socket,
    testnet,
    verbose: true,
  );

  await _sendVerack(
    socket,
    testnet,
  );
}

Future<void> _sendMessage(
  Socket socket,
  Uint8List header,
  Uint8List payload,
  Command command,
) async {
  late final Uint8List message;
  if (payload.isEmpty) {
    message = header;
  } else {
    message = Uint8List.fromList([...header, ...payload]);
  }
  socket.add(message);
  print('Send: ${command.string}');
  await Future<void>.delayed(const Duration(milliseconds: 500));
}

Future<void> _sendVersionMessage(
  Socket socket,
  bool testnet, {
  bool verbose = false,
}) async {
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

  if (verbose) {
    print(
      jsonEncode({
        'Version': {
          'messageHeader': header.toJson(),
          'versionMessage': payload.toJson()
        },
      }),
    );
  }

  await _sendMessage(socket, header.serialize(), serializedPayload, command);
}

Future<void> _sendVerack(
  Socket socket,
  bool testnet, {
  bool verbose = false,
}) async {
  const command = Command.verack;
  final magic = testnet ? Magic.testnet : Magic.mainnet;
  final payload = Uint8List(0);

  final header = MessageHeader.create(
    magic: magic,
    command: command,
    payload: payload,
  );

  if (verbose) {
    print(
      jsonEncode({
        'Verack': {
          'messageHeader': header.toJson(),
        },
      }),
    );
  }

  await _sendMessage(socket, header.serialize(), payload, command);
}
