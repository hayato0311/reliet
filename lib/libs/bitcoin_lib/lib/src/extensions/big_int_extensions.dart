import 'dart:typed_data';

extension BigIntExtensions on BigInt {
  String toHex() {
    final hex = toRadixString(16);
    return hex.padLeft(hex.length + (hex.length % 2), '0');
  }

  Uint8List toUint8List() {
    final hex = toHex();
    final result = Uint8List(hex.length ~/ 2);
    for (var i = 0; i < hex.length; i += 2) {
      final byte = int.parse(hex.substring(i, i + 2));
      result[i ~/ 2] = byte;
    }
    return result;
  }
}
