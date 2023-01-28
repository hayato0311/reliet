import 'dart:typed_data';

import '../../utils/encode.dart';
import 'network_address.dart';
import 'variable_length_string.dart';
import 'services.dart';
import 'version.dart';
import 'nonce.dart';
import 'timestamp.dart';
import 'start_height.dart';

class VersionMessage {
  final Version version;
  final Services services;
  final Timestamp timestamp;
  final NetAddr addrRecv;
  final NetAddr addrFrom;
  final Nonce nonce;
  final VarStr userAgent;
  final StartHeight startHeight;
  final bool relay;

  VersionMessage._internal({
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

  factory VersionMessage.create({
    required Version version,
    required Services services,
    required NetAddr addrRecv,
    required NetAddr addrFrom,
    required Nonce nonce,
    required VarStr userAgent,
    required StartHeight startHeight,
    required bool relay,
  }) {
    final int unixtime = (DateTime.now().millisecondsSinceEpoch / 1000).floor();

    return VersionMessage._internal(
      version: version,
      services: services,
      timestamp: Timestamp(unixtime),
      addrRecv: addrRecv,
      addrFrom: addrFrom,
      nonce: nonce,
      userAgent: userAgent,
      startHeight: startHeight,
      relay: relay,
    );
  }

  Uint8List serialize() {
    List<int> byteList = [
      ...version.serialize(),
      ...services.serialize(),
      ...timestamp.serialize(),
      ...addrRecv.serialize(),
      ...addrFrom.serialize(),
      ...nonce.serialize(),
      ...userAgent.serialize(),
      ...startHeight.serialize(),
      boolToint(relay),
    ];

    return Uint8List.fromList(byteList);
  }
}
