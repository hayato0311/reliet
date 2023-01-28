import 'dart:typed_data';

class Nonce {
  final List<int> bytes;

  Nonce._internal(this.bytes);

  factory Nonce(List<int> bytes) {
    if (bytes.length != 8) {
      throw const FormatException("the length must be 8");
    }

    return Nonce._internal(bytes);
  }

  Uint8List serialize() => Uint8List.fromList(bytes.reversed.toList());
}
