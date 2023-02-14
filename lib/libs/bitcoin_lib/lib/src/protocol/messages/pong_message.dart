import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../types/nonce.dart';

@immutable
class PongMessage {
  const PongMessage(this.nonce);

  factory PongMessage.deserialize(Uint8List bytes) {
    const startIndex = 0;
    final nonce = Nonce.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Nonce.bytesLength(),
      ),
    );

    return PongMessage(nonce);
  }

  final Nonce nonce;

  Map<String, dynamic> toJson() => {'nonce': nonce.toJson()};

  Uint8List serialize() {
    final byteList = <int>[...nonce.serialize()];

    return Uint8List.fromList(byteList);
  }
}
