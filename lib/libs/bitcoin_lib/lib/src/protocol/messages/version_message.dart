import 'dart:typed_data';

import '../../extensions/bool_extensions.dart';
import '../types/network_address.dart';
import '../types/nonce.dart';
import '../types/services.dart';
import '../types/start_height.dart';
import '../types/timestamp.dart';
import '../types/variable_length_integer.dart';
import '../types/variable_length_string.dart';
import '../types/version.dart';

class VersionMessage {
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
    final version = Version.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Version.bytesLength(),
      ),
    );

    startIndex += Version.bytesLength();

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

    final userAgentStringLength =
        _bytesToUserAgentStringLength(bytes.sublist(startIndex));

    final userAgent = VarStr.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + VarStr.bytesLength(userAgentStringLength),
      ),
    );

    startIndex += VarStr.bytesLength(userAgentStringLength);

    final startHeight = StartHeight.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + StartHeight.bytesLength(),
      ),
    );

    startIndex += StartHeight.bytesLength();

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

  static VarInt _bytesToUserAgentStringLength(Uint8List bytes) {
    final headByte = bytes[0];
    final varIntLength = VarInt.bytesLength(headByte);

    return VarInt.deserialize(bytes.sublist(0, varIntLength));
  }

  final Version version;
  final Services services;
  final Timestamp timestamp;
  final NetAddr addrRecv;
  final NetAddr addrFrom;
  final Nonce nonce;
  final VarStr userAgent;
  final StartHeight startHeight;
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
