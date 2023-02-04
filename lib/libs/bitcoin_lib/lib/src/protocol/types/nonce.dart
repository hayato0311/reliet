import 'dart:typed_data';

class Nonce {
  factory Nonce(List<int> bytes) {
    if (bytes.length != 8) {
      throw const FormatException('the length must be 8');
    }

    return Nonce._internal(bytes);
  }

  factory Nonce.deserialize(Uint8List bytes) => Nonce(bytes.reversed.toList());

  Nonce._internal(this.bytes);

  static int bytesLength() => 8;

  // uint64be
  final List<int> bytes;

  Map<String, dynamic> toJson() => {'bytes': bytes};

  // to uint64le
  Uint8List serialize() => Uint8List.fromList(bytes.reversed.toList());
}
