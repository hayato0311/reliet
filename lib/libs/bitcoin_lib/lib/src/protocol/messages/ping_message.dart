import 'dart:typed_data';

import '../types/nonce.dart';

class PingMessage {
  PingMessage(this.nonce);

  factory PingMessage.deserialize(Uint8List bytes) {
    const startIndex = 0;
    final nonce = Nonce.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Nonce.bytesLength(),
      ),
    );

    return PingMessage(nonce);
  }

  final Nonce nonce;

  Map<String, dynamic> toJson() => {'nonce': nonce.toJson()};

  Uint8List serialize() {
    final byteList = <int>[...nonce.serialize()];

    return Uint8List.fromList(byteList);
  }
}
