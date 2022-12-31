import 'dart:typed_data';

import '../../encode.dart';
import 'network_address.dart';
import 'variable_length_string.dart';
import 'port.dart';
import 'services.dart';

class Version {
  final int version;
  final int services;
  final int timestamp;
  final NetAddr addrRecv;
  final NetAddr addrFrom;
  final int nonce;
  final VarStr userAgent;
  final int startHeight;
  final bool relay;

  Version({
    required this.version,
    required this.services,
    required this.timestamp,
    required this.addrRecv,
    required this.addrFrom,
    required this.nonce,
    required this.userAgent,
    required this.startHeight,
    required this.relay,
  });

  static Version create(
      {required int version, required VarStr userAgent, bool testnet = false}) {
    // TODO: add args
    final int unixtime = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    final int port = testnet ? Port.testnet : Port.main;
    final int services = Services(nodeNetwork: true).value;

    final NetAddr addr = NetAddr(
      services: services,
      ipbe: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 127, 0, 0, 1],
      port: port,
    );

    return Version(
      version: version,
      services: services,
      timestamp: unixtime,
      addrRecv: addr,
      addrFrom: addr,
      nonce: 0,
      userAgent: userAgent,
      startHeight: 0,
      relay: false,
    );
  }

  Uint8List serialize() {
    List<int> byteList = [
      ...int32leBytes(version).toList(),
      ...uint64leBytes(services).toList(),
      ...int64leBytes(timestamp).toList(),
      ...addrRecv.serialize().toList(),
      ...addrFrom.serialize().toList(),
      ...uint64leBytes(nonce).toList(),
      ...userAgent.serialize().toList(),
      ...int32leBytes(startHeight).toList(),
      boolToint(relay),
    ];

    return Uint8List.fromList(byteList);
  }
}
