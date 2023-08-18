import 'dart:typed_data';

extension Uint8ListExtensions on Uint8List {
  String toHex({bool prefix = true}) => [
        if (prefix) '0x' else '',
        for (var byte in this) byte.toRadixString(16).padLeft(2, '0')
      ].join();
}
