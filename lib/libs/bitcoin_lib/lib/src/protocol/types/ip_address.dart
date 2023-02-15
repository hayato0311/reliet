import 'dart:typed_data';

import 'package:meta/meta.dart';

@immutable
class IpAddr {
  factory IpAddr(List<int> input) {
    final bytes = _convertToIPv4MappedIPv6Addr(input);

    return IpAddr._internal(bytes);
  }
  const IpAddr._internal(this.bytes);

  factory IpAddr.deserialize(Uint8List bytes) {
    if (bytes.length != 16) {
      throw const FormatException('Given bytes is not IPv4 or IPv6 address.');
    }
    return IpAddr._internal(bytes);
  }

  static int bytesLength() => 16;

  final List<int> bytes;

  static List<int> _convertToIPv4MappedIPv6Addr(List<int> bytes) {
    if (bytes.length == 4) {
      return [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, ...bytes];
    }
    if (bytes.length == 16) {
      return bytes;
    }
    throw const FormatException('Given input is not IPv4 or IPv6 address.');
  }

  Map<String, dynamic> toJson() => {'bytes': bytes};

  Uint8List serialize() => Uint8List.fromList(bytes);
}
