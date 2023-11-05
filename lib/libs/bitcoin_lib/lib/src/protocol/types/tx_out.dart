import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'bases/int64le.dart';
import 'script_pubkey.dart';
import 'script_type.dart';

@immutable
class TxOut {
  factory TxOut(Int64le value, ScriptPubKey scriptPubkey) {
    return TxOut._internal(value, scriptPubkey);
  }
  const TxOut._internal(this.value, this.scriptPubkey);

  factory TxOut.deserialize(Uint8List bytes) {
    var startIndex = 0;
    final value = Int64le.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Int64le.bytesLength(),
      ),
    );
    startIndex += Int64le.bytesLength();

    final scriptPubkey = ScriptPubKey.deserialize(bytes.sublist(startIndex));
    startIndex += scriptPubkey.bytesLength();

    return TxOut._internal(
      value,
      scriptPubkey,
    );
  }

  final Int64le value;
  final ScriptPubKey scriptPubkey;

  int bytesLength() => Int64le.bytesLength() + scriptPubkey.bytesLength();

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

  bool empty() => scriptPubkey.type == ScriptType.empty;
}
