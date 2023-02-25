import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'script_pubkey.dart';
import 'tx_value.dart';

@immutable
class TxOut {
  factory TxOut(TxValue value, ScriptPubKey scriptPubkey) {
    return TxOut._internal(value, scriptPubkey);
  }
  const TxOut._internal(this.value, this.scriptPubkey);

  factory TxOut.deserialize(Uint8List bytes) {
    var startIndex = 0;
    final value = TxValue.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + TxValue.bytesLength(),
      ),
    );
    startIndex += TxValue.bytesLength();

    final scriptPubkey = ScriptPubKey.deserialize(bytes.sublist(startIndex));
    startIndex += scriptPubkey.bytesLength();

    return TxOut._internal(
      value,
      scriptPubkey,
    );
  }

  final TxValue value;
  final ScriptPubKey scriptPubkey;

  int bytesLength() => TxValue.bytesLength() + scriptPubkey.bytesLength();

  Map<String, dynamic> toJson() => {
        'value': value.toJson(),
        'scriptPubkey': scriptPubkey.toJson(),
      };

  Uint8List serialize() {
    final byteList = <int>[
      ...value.serialize(),
      ...scriptPubkey.serialize(),
    ];

    return Uint8List.fromList(byteList);
  }
}
