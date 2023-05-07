import 'dart:typed_data';

import '../../extensions/int_extensions.dart';

enum ProtocolVersion {
  // in Bitcoin Core, this value is 70016
  defaultVersion(70015),

  // initial proto version, to be increased after version/verack negotiation
  initProtoVersion(209),

  // disconnect from peers older than this proto version
  minPeerProtoVersion(31800),

  // disconnect from peers older than this proto version
  bip0031Version(60000),

  // BIP 0031, pong message, is enabled for all versions AFTER this one
  noBloomVersion(70011),

  // "sendheaders" command and announcing blocks with headers starts with this version
  sendHeadersVersion(70012),

  // "feefilter" tells peers to filter invs to you by fee starts with this version
  feeFilterVersion(70013),

  // short-id-based block download starts with this version
  shortIdsBlocksVersion(70014),

  // not banning for invalid compact blocks starts with this version
  invalidCbNoBanVersion(70015),

  // "wtxidrelay" command for wtxid-based relay starts with this version
  wtxidRelayVersion(70016);

  const ProtocolVersion(this.value);

  factory ProtocolVersion.deserialize(Uint8List bytes) {
    final commandValue = CreateInt.fromInt32leBytes(bytes);
    if (commandValue == 209) {
      return ProtocolVersion.initProtoVersion;
    } else if (commandValue == 31800) {
      return ProtocolVersion.minPeerProtoVersion;
    } else if (commandValue == 60000) {
      return ProtocolVersion.bip0031Version;
    } else if (commandValue == 70011) {
      return ProtocolVersion.noBloomVersion;
    } else if (commandValue == 70012) {
      return ProtocolVersion.sendHeadersVersion;
    } else if (commandValue == 70013) {
      return ProtocolVersion.feeFilterVersion;
    } else if (commandValue == 70014) {
      return ProtocolVersion.shortIdsBlocksVersion;
    } else if (commandValue == 70015) {
      return ProtocolVersion.invalidCbNoBanVersion;
    } else if (commandValue == 70016) {
      return ProtocolVersion.wtxidRelayVersion;
    } else {
      throw ArgumentError('Undefined version');
    }
  }

  static int bytesLength() => 4;

  final int value;

  Map<String, dynamic> toJson() => {'value': value};

  Uint8List serialize() => value.toInt32leBytes();
}
