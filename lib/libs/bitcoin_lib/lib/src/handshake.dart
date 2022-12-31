import 'dart:io';
import 'dart:typed_data';
import 'dart:math';

import 'protocol/types/port.dart';
import 'protocol/types/version.dart';
import 'protocol/types/message_header.dart';
import 'protocol/types/variable_length_string.dart';
import 'chain_params.dart';

const bool testnet = true;

void handshake() async {
  const List<String> dnsSeeds =
      testnet ? TestnetParams.dnsSeeds : MainParams.dnsSeeds;

  final socket = await Socket.connect(
    dnsSeeds[Random().nextInt(dnsSeeds.length)],
    testnet ? Port.testnet : Port.main,
  );
  const int protocolVersion = 70015;
  const String userAgentString = "";
  final VarStr userAgent = VarStr(userAgentString);
  print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

  // listen for responses from the server
  socket.listen(
    // handle data from the server
    (Uint8List data) {
      final serverResponse = String.fromCharCodes(data);
      print('Server: $serverResponse');
    },

    // handle errors
    onError: (error) {
      print(error);
      socket.destroy();
    },

    // handle server ending connection
    onDone: () {
      print('Server left.');
      socket.destroy();
    },
  );

  const String command = "version";

  final Uint8List payload = Version.create(
    version: protocolVersion,
    userAgent: userAgent,
    testnet: testnet,
  ).serialize();

  final Uint8List header =
      MessageHeader.create(command, payload, testnet: testnet).serialize();

  await sendMessage(socket, header, payload, command);
}

Future<void> sendMessage(
  Socket socket,
  Uint8List header,
  Uint8List payload,
  String command,
) async {
  final Uint8List message = Uint8List.fromList([...header, ...payload]);
  socket.add(message);
  print('Send: $command ${payload.length}');
  await Future.delayed(const Duration(seconds: 2));
}
