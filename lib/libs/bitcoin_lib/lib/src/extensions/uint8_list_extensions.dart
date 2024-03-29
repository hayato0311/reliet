import 'dart:typed_data';

extension Uint8ListExtensions on Uint8List {
  String toHex() =>
      [for (var byte in this) byte.toRadixString(16).padLeft(2, '0')].join();
}
