import 'dart:typed_data';

import '../../extensions/bool_extentions.dart';
import 'network_address.dart';
import 'nonce.dart';
import 'services.dart';
import 'start_height.dart';
import 'timestamp.dart';
import 'variable_length_string.dart';
import 'version.dart';

class VersionMessage {
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
    final unixtime = (DateTime.now().millisecondsSinceEpoch / 1000).floor();

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
  final Version version;
  final Services services;
  final Timestamp timestamp;
  final NetAddr addrRecv;
  final NetAddr addrFrom;
  final Nonce nonce;
  final VarStr userAgent;
  final StartHeight startHeight;
  final bool relay;

  Uint8List serialize() {
    final byteList = <int>[
      ...version.serialize(),
      ...services.serialize(),
      ...timestamp.serialize(),
      ...addrRecv.serialize(),
      ...addrFrom.serialize(),
      ...nonce.serialize(),
      ...userAgent.serialize(),
      ...startHeight.serialize(),
      relay.toInt(),
    ];

    return Uint8List.fromList(byteList);
  }
}
