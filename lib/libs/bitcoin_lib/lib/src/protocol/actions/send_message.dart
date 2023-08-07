import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../messages/get_c_filters_message.dart';
import '../messages/get_data_message.dart';
import '../messages/ping_message.dart';
import '../messages/pong_message.dart';
import '../messages/version_message.dart';
import '../types/bases/int32le.dart';
import '../types/bases/uint32le.dart';
import '../types/command.dart';
import '../types/filter_type.dart';
import '../types/hash256.dart';
import '../types/inventory.dart';
import '../types/ip_address.dart';
import '../types/magic.dart';
import '../types/message_header.dart';
import '../types/network_address.dart';
import '../types/nonce.dart';
import '../types/port.dart';
import '../types/protocol_version.dart';
import '../types/service.dart';
import '../types/services.dart';
import '../types/variable_length_string.dart';

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

Future<void> sendVersionMessage(
  Socket socket, {
  bool testnet = false,
  bool verbose = false,
}) async {
  final addrRecv = NetAddr(
    services: ServiceFlags(const [ServiceFlag.nodeZero]),
    ipAddr: IpAddr(const [0, 0, 0, 0]),
    port: testnet ? Port(Port.testnet) : Port(Port.mainnet),
  );

  const userAgentString = '';
  final userAgent = VarStr(userAgentString);

  final services = ServiceFlags(const [ServiceFlag.nodeZero]);

  final addrFrom = NetAddr(
    services: services,
    ipAddr: IpAddr(const [0, 0, 0, 0]),
    port: Port(Port.zero),
  );

  final payload = VersionMessage.create(
    version: ProtocolVersion.defaultVersion,
    services: services,
    addrRecv: addrRecv,
    addrFrom: addrFrom,
    nonce: Nonce(const [0, 0, 0, 0, 0, 0, 0, 0]),
    userAgent: userAgent,
    startHeight: Int32le(0),
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

Future<void> sendVerackMessage(
  Socket socket, {
  bool testnet = false,
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

Future<void> sendPongMessage(
  Socket socket,
  Nonce nonce, {
  bool testnet = false,
  bool verbose = false,
}) async {
  const command = Command.pong;
  final magic = testnet ? Magic.testnet : Magic.mainnet;
  final payload = PongMessage(nonce);

  final serializedPayload = payload.serialize();

  final header = MessageHeader.create(
    magic: magic,
    command: command,
    payload: serializedPayload,
  );

  if (verbose) {
    print(
      jsonEncode({
        'pong': {
          'messageHeader': header.toJson(),
          'pongMessage': payload.toJson()
        },
      }),
    );
  }

  await _sendMessage(socket, header.serialize(), serializedPayload, command);
}

Future<void> sendPingMessage(
  Socket socket, {
  bool testnet = false,
  bool verbose = false,
}) async {
  const command = Command.ping;
  final magic = testnet ? Magic.testnet : Magic.mainnet;
  final payload = PingMessage(Nonce.create());

  final serializedPayload = payload.serialize();

  final header = MessageHeader.create(
    magic: magic,
    command: command,
    payload: serializedPayload,
  );

  if (verbose) {
    print(
      jsonEncode({
        'ping': {
          'messageHeader': header.toJson(),
          'pingMessage': payload.toJson()
        },
      }),
    );
  }

  await _sendMessage(socket, header.serialize(), serializedPayload, command);
}

Future<void> sendGetDataMessage(
  Socket socket,
  List<Inventory> inventories, {
  bool testnet = false,
  bool verbose = false,
}) async {
  const command = Command.getdata;
  final magic = testnet ? Magic.testnet : Magic.mainnet;
  final payload = GetDataMessage(inventories);

  final serializedPayload = payload.serialize();

  final header = MessageHeader.create(
    magic: magic,
    command: command,
    payload: serializedPayload,
  );

  if (verbose) {
    print(
      jsonEncode({
        'getData': {
          'messageHeader': header.toJson(),
          'getDataMessage': payload.toJson()
        },
      }),
    );
  }

  await _sendMessage(socket, header.serialize(), serializedPayload, command);
}

Future<void> sendGetCFiltersMessage(
  Socket socket,
  Uint32le startHeight,
  Hash256 stopHash, {
  bool testnet = false,
  bool verbose = false,
  FilterType filterType = FilterType.basic,
}) async {
  const command = Command.getcfilters;
  final magic = testnet ? Magic.testnet : Magic.mainnet;
  final payload = GetCFiltersMessage(
    filterType: filterType,
    startHeight: startHeight,
    stopHash: stopHash,
  );

  final serializedPayload = payload.serialize();

  final header = MessageHeader.create(
    magic: magic,
    command: command,
    payload: serializedPayload,
  );

  if (verbose) {
    print(
      jsonEncode({
        'getCFilters': {
          'messageHeader': header.toJson(),
          'getDataMessage': payload.toJson()
        },
      }),
    );
  }

  await _sendMessage(socket, header.serialize(), serializedPayload, command);
}
