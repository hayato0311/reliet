import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../types/lock_time.dart';
import '../types/tx_in.dart';
import '../types/tx_out.dart';
import '../types/tx_version.dart';
import '../types/variable_length_integer.dart';

@immutable
class TxMessage {
  // TODO: Support for segwit tx
  factory TxMessage({
    required TxVersion version,
    required List<TxIn> txIns,
    required List<TxOut> txOuts,
    // required List<TxWitness> txWitnesses,
  }) {
    final txInCount = VarInt(txIns.length);
    final txOutCount = VarInt(txOuts.length);
    // final flag = txWitnesses.isNotEmpty || false;

    return TxMessage._internal(
      version,
      // flag,
      txInCount,
      txIns,
      txOutCount,
      txOuts,
      // txWitnesses,
      LockTime(0),
    );
  }

  const TxMessage._internal(
    this.version,
    // this.flag,
    this.txInCount,
    this.txIns,
    this.txOutCount,
    this.txOuts,
    // this.txWitnesses,
    this.lockTime,
  );

  factory TxMessage.deserialize(Uint8List bytes) {
    var startIndex = 0;
    final version = TxVersion.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + TxVersion.bytesLength(),
      ),
    );
    startIndex += TxVersion.bytesLength();

    final txInCount = VarInt.deserialize(bytes.sublist(startIndex));
    startIndex += txInCount.bytesLength();

    final txIns = <TxIn>[];
    for (var i = 0; i < txInCount.value; i++) {
      final txIn = TxIn.deserialize(bytes.sublist(startIndex));
      txIns.add(txIn);
      startIndex += txIn.bytesLength();
    }

    final txOutCount = VarInt.deserialize(bytes.sublist(startIndex));
    startIndex += txOutCount.bytesLength();

    final txOuts = <TxOut>[];
    for (var i = 0; i < txOutCount.value; i++) {
      final txOut = TxOut.deserialize(bytes.sublist(startIndex));
      txOuts.add(txOut);
      startIndex += txOut.bytesLength();
    }

    final lockTime = LockTime.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + LockTime.bytesLength(),
      ),
    );
    startIndex += LockTime.bytesLength();

    return TxMessage._internal(
      version,
      // flag,
      txInCount,
      txIns,
      txOutCount,
      txOuts,
      // txWitnesses,
      lockTime,
    );
  }

  final TxVersion version;
  // final bool flag;
  final VarInt txInCount;
  final List<TxIn> txIns;
  final VarInt txOutCount;
  final List<TxOut> txOuts;
  // final List<TxWitness> txWitnesses;
  final LockTime lockTime;

  int bytesLength() {
    var txInsByteLength = 0;
    for (final txIn in txIns) {
      txInsByteLength += txIn.bytesLength();
    }

    var txOutsByteLength = 0;
    for (final txOut in txOuts) {
      txOutsByteLength += txOut.bytesLength();
    }

    return TxVersion.bytesLength() +
        txInCount.bytesLength() +
        txInsByteLength +
        txOutCount.bytesLength() +
        txOutsByteLength +
        LockTime.bytesLength();
  }

  Map<String, dynamic> toJson() => {
        'version': version.toJson(),
        // 'flag': flag.toString(),
        'txInCount': txInCount.toJson(),
        'txIns': [for (var txIn in txIns) txIn.toJson()],
        'txOutCount': txOutCount.toJson(),
        'txOuts': [for (var txOut in txOuts) txOut.toJson()],
        // 'txWitnesses': [for (var txWitness in txWitnesses) txWitness.toJson()],
        'lockTime': lockTime.toJson(),
      };

  Uint8List serialize() {
    final byteList = <int>[
      ...version.serialize(),
      ...txInCount.serialize(),
      for (var txIn in txIns) ...txIn.serialize(),
      ...txOutCount.serialize(),
      for (var txOut in txOuts) ...txOut.serialize(),
      ...lockTime.serialize(),
    ];

    return Uint8List.fromList(byteList);
  }
}
