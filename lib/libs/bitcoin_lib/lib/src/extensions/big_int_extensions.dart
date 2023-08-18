import 'dart:typed_data';

extension BigIntExtensions on BigInt {
  String toHex({bool prefix = true}) {
    final hexWithoutPadding = toRadixString(16);
    final hexWithoutPrefix = hexWithoutPadding.padLeft(
      hexWithoutPadding.length + (hexWithoutPadding.length % 2),
      '0',
    );

    if (prefix) {
      return '0x$hexWithoutPrefix';
    }
    return hexWithoutPrefix;
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
