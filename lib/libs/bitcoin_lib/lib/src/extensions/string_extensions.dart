import 'dart:convert';
import 'dart:typed_data';

extension StringExtensions on String {
  // to fixed length bytecodes

  Uint8List encodeAsUtf8([int length = -1]) {
    final byteList = List<int>.from(utf8.encode(this));

    if (length == -1) {
      return Uint8List.fromList(byteList);
    }

    if (byteList.length > length) {
      throw ArgumentError('The string is longer than given length');
    }

    if (byteList.length < length) {
      byteList.insertAll(
        byteList.length,
        List.generate(length - byteList.length, (i) => 0),
      );
    }
    return Uint8List.fromList(byteList);
  }

  Uint8List hexToBytes() {
    final bytes = <int>[];
    var string = this;

    if (string.length >= 2 && '0x' == substring(0, 2)) {
      string = replaceFirst('0x', '');
    }
    // BigInt.toRadixString(16) returns minimal string, which may have odd length
    // e.g., BigInt.from(256) → "100" (3 chars)
    // Pad with leading 0 to normalize to even length for 2-char processing
    if (string.length % 2 != 0) {
      string = '0$string';
    }
    for (var i = 0; i < string.length; i += 2) {
      final byte = int.parse(string.substring(i, i + 2), radix: 16);
      bytes.add(byte);
    }
    return Uint8List.fromList(bytes);
  }
}
