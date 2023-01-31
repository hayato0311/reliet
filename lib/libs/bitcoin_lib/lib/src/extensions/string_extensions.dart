import 'dart:convert';
import 'dart:typed_data';

extension StringExtensions on String {
  // to fixed length bytecodes

  Uint8List toBytes([int length = -1]) {
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
}