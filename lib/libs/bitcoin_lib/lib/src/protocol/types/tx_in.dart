import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'bases/uint32le.dart';
import 'script_sig.dart';
import 'tx_out_point.dart';

@immutable
class TxIn {
  factory TxIn(
    TxOutPoint previousOutput,
    ScriptSig scriptSig,
    Uint32le sequence,
  ) =>
      TxIn._internal(
        previousOutput,
        scriptSig,
        sequence,
      );

  const TxIn._internal(
    this.previousOutput,
    this.scriptSig,
    this.sequence,
  );

  factory TxIn.deserialize(Uint8List bytes) {
    var startIndex = 0;
    final previousOutput = TxOutPoint.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + TxOutPoint.bytesLength(),
      ),
    );
    startIndex += TxOutPoint.bytesLength();

    final scriptSig = ScriptSig.deserialize(bytes.sublist(startIndex));
    startIndex += scriptSig.bytesLength();

    final sequence = Uint32le.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Uint32le.bytesLength(),
      ),
    );
    startIndex += Uint32le.bytesLength();

    return TxIn._internal(
      previousOutput,
      scriptSig,
      sequence,
    );
  }

  final TxOutPoint previousOutput;
  final ScriptSig scriptSig;
  final Uint32le sequence;

  int bytesLength() =>
      TxOutPoint.bytesLength() +
      scriptSig.bytesLength() +
      Uint32le.bytesLength();

  Map<String, dynamic> toJson() => {
        'previousOutput': previousOutput.toJson(),
        'scriptSig': scriptSig.toJson(),
        'sequence': sequence.toJson(),
      };

  Uint8List serialize() {
    final byteList = <int>[
      ...previousOutput.serialize(),
      ...scriptSig.serialize(),
      ...sequence.serialize(),
    ];

    return Uint8List.fromList(byteList);
  }

  bool isCoinBase() => previousOutput.isCoinBase();
}
