import 'dart:typed_data';

extension BigIntExtensions on BigInt {
  String toHex() {
    final hex = toRadixString(16);
    return '0x${hex.padLeft(hex.length + (hex.length % 2), '0')}';
  }

  Uint8List toUint8List() {
    final hex = toHex();
    if (!hex.startsWith('0x') || hex.length % 2 != 0) {
      throw ArgumentError('Hex string has incorrect format: $hex');
    }

    final validHexPattern = RegExp(r'^0x[0-9a-fA-F]*$');
    if (!validHexPattern.hasMatch(hex)) {
      throw ArgumentError('Hex string contains invalid characters: $hex');
    }

    final hexWithoutPrefix = hex.substring(2);
    final result = Uint8List(hexWithoutPrefix.length ~/ 2);
    for (var i = 0; i < hexWithoutPrefix.length; i += 2) {
      final byte = int.parse(hexWithoutPrefix.substring(i, i + 2), radix: 16);
      result[i ~/ 2] = byte;
    }
    return result;
  }
}
