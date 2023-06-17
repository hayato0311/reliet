import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../extensions/bool_extensions.dart';
import '../types/bases/int32le.dart';
import '../types/network_address.dart';
import '../types/nonce.dart';
import '../types/protocol_version.dart';
import '../types/services.dart';
import '../types/timestamp.dart';
import '../types/variable_length_string.dart';

@immutable
class VersionMessage {
  const VersionMessage._internal({
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
    required ProtocolVersion version,
    required Services services,
    required NetAddr addrRecv,
    required NetAddr addrFrom,
    required Nonce nonce,
    required VarStr userAgent,
    required Int32le startHeight,
    required bool relay,
  }) {
    return VersionMessage._internal(
      version: version,
      services: services,
      timestamp: Timestamp.create(),
      addrRecv: addrRecv,
      addrFrom: addrFrom,
      nonce: nonce,
      userAgent: userAgent,
      startHeight: startHeight,
      relay: relay,
    );
  }

  factory VersionMessage.deserialize(Uint8List bytes) {
    var startIndex = 0;
    final version = ProtocolVersion.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + ProtocolVersion.bytesLength(),
      ),
    );

    startIndex += ProtocolVersion.bytesLength();

    final services = Services.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Services.bytesLength(),
      ),
    );

    startIndex += Services.bytesLength();

    final timestamp = Timestamp.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Timestamp.bytesLength(),
      ),
    );

    startIndex += Timestamp.bytesLength();

    final addrRecv = NetAddr.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + NetAddr.bytesLength(),
      ),
    );

    startIndex += NetAddr.bytesLength();

    final addrFrom = NetAddr.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + NetAddr.bytesLength(),
      ),
    );

    startIndex += NetAddr.bytesLength();

    final nonce = Nonce.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Nonce.bytesLength(),
      ),
    );

    startIndex += Nonce.bytesLength();

    final userAgent = VarStr.deserialize(bytes.sublist(startIndex));
    startIndex += userAgent.bytesLength();

    final startHeight = Int32le.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Int32le.bytesLength(),
      ),
    );

    startIndex += Int32le.bytesLength();

    final relay = bytes[startIndex] == 1;

    startIndex += 1;

    if (bytes.length != startIndex) {
      throw ArgumentError('Given bytes is invalid');
    }

    return VersionMessage._internal(
      version: version,
      services: services,
      timestamp: timestamp,
      addrRecv: addrRecv,
      addrFrom: addrFrom,
      nonce: nonce,
      userAgent: userAgent,
      startHeight: startHeight,
      relay: relay,
    );
  }

  final ProtocolVersion version;
  final Services services;
  final Timestamp timestamp;
  final NetAddr addrRecv;
  final NetAddr addrFrom;
  final Nonce nonce;
  final VarStr userAgent;
  final Int32le startHeight;
  final bool relay;

  Map<String, dynamic> toJson() => {
        'version': version.toJson(),
        'services': services.toJson(),
        'timestamp': timestamp.toJson(),
        'addrRecv': addrRecv.toJson(),
        'addrFrom': addrFrom.toJson(),
        'nonce': nonce.toJson(),
        'userAgent': userAgent.toJson(),
        'startHeight': startHeight.toJson(),
        'relay': relay,
      };

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
