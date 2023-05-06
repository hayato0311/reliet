import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

import '../../extensions/string_extensions.dart';

@immutable
class Hash256 {
  factory Hash256.create(List<int> bytes) {
    final digest = sha256.convert(bytes);
    return Hash256._internal(sha256.convert(digest.bytes).bytes);
  }

  factory Hash256.fromHexString(String hexString) {
    return Hash256._internal(hexString.hexToBytes().toList());
  }

  factory Hash256.deserialize(Uint8List bytes) {
    if (bytes.length != bytesLength()) {
      throw ArgumentError('''
The length of given bytes is invalid
Expected: ${bytesLength()}, Actual: ${bytes.length}
''');
    }
    return Hash256._internal(bytes.toList().reversed.toList());
  }

  const Hash256._internal(this.bytes);

  static int bytesLength() => 32;

  // final Digest digest;
  final List<int> bytes;

  Map<String, dynamic> toJson() => {
        'bytes': [
          for (var byte in bytes) byte.toRadixString(16).padLeft(2, '0')
        ].join()
      };

  Uint8List serialize() => Uint8List.fromList(bytes.reversed.toList());
}
