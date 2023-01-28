import 'dart:typed_data';

class IpAddr {
  final List<int> bytes;

  IpAddr._internal(this.bytes);

  factory IpAddr(List<int> input) {
    List<int> bytes = _convertToIPv4MappedIPv6Addr(input);

    return IpAddr._internal(bytes);
  }

  static List<int> _convertToIPv4MappedIPv6Addr(List<int> input) {
    if (input.length == 4) {
      return [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, ...input];
    }
    if (input.length == 16) {
      return input;
    }
    throw const FormatException("Given input is not IPv4 or IPv6 address.");
  }

  Uint8List serialize() => Uint8List.fromList(bytes);
}
