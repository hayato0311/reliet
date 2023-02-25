import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'script_sig.dart';
import 'sequence.dart';
import 'tx_out_point.dart';

@immutable
class TxIn {
  factory TxIn(
    TxOutPoint previousOutput,
    ScriptSig scriptSig,
    Sequence sequence,
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

    final sequence = Sequence.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Sequence.bytesLength(),
      ),
    );
    startIndex += Sequence.bytesLength();

    return TxIn._internal(
      previousOutput,
      scriptSig,
      sequence,
    );
  }

  final TxOutPoint previousOutput;
  final ScriptSig scriptSig;
  final Sequence sequence;

  int bytesLength() =>
      TxOutPoint.bytesLength() +
      scriptSig.bytesLength() +
      Sequence.bytesLength();

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
}
