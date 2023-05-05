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
    for (var i = 0; i < length; i += 2) {
      final byte = int.parse(substring(i, i + 2), radix: 16);
      bytes.add(byte);
    }
    return Uint8List.fromList(bytes);
  }
}

extension CreateString on String {
  static String fromBytes(Uint8List bytes) {
    final removedZeroPaddingBytes = bytes.where((value) => value != 0).toList();
    return utf8.decode(removedZeroPaddingBytes);
  }
}
