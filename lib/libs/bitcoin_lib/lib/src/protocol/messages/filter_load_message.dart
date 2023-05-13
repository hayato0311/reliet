import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../types/bases/uint32le.dart';
import '../types/var_bytes.dart';

@immutable
class FilterLoadMessage {
  const FilterLoadMessage({
    required this.filter,
    required this.nHashFuncs,
    required this.nTweak,
    required this.nFlags,
  });

  factory FilterLoadMessage.deserialize(Uint8List bytes) {
    var startIndex = 0;
    final filter = VarBytes.deserialize(
      bytes.sublist(startIndex),
    );
    startIndex += filter.bytesLength();

    final nHashFuncs = Uint32le.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Uint32le.bytesLength(),
      ),
    );
    startIndex += Uint32le.bytesLength();

    final nTweak = Uint32le.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + Uint32le.bytesLength(),
      ),
    );
    startIndex += Uint32le.bytesLength();

    final nFlags = BloomFlag.deserialize(
      bytes.sublist(
        startIndex,
        startIndex + BloomFlag.bytesLength(),
      ),
    );
    startIndex += BloomFlag.bytesLength();

    return FilterLoadMessage(
      filter: filter,
      nHashFuncs: nHashFuncs,
      nTweak: nTweak,
      nFlags: nFlags,
    );
  }

  final VarBytes filter;
  final Uint32le nHashFuncs;
  final Uint32le nTweak;
  final BloomFlag nFlags;

  int bytesLength() {
    return filter.bytesLength() +
        Uint32le.bytesLength() +
        Uint32le.bytesLength() +
        BloomFlag.bytesLength();
  }

  Map<String, dynamic> toJson() => {
        'filter': filter.toJson(),
        'nHashFuncs': nHashFuncs.toJson(),
        'nTweak': nTweak.toJson(),
        'nFlags': nFlags.toJson(),
      };

  Uint8List serialize() {
    final byteList = <int>[
      ...filter.serialize(),
      ...nHashFuncs.serialize(),
      ...nTweak.serialize(),
      ...nFlags.serialize(),
    ];

    return Uint8List.fromList(byteList);
  }
}

enum BloomFlag {
  // Never update the filter with outpoints.
  none(0),
  // Always update the filter with outpoints.
  all(1),
  // Only update the filter with outpoints if it is P2PK or P2MS
  pubKeyOnly(2);

  const BloomFlag(this.value);

  static BloomFlag deserialize(Uint8List bytes) {
    final value = bytes[0];
    switch (value) {
      case 0:
        return BloomFlag.none;
      case 1:
        return BloomFlag.all;
      case 2:
        return BloomFlag.pubKeyOnly;
      default:
        throw Exception('Invalid BloomFlag value: $value');
    }
  }

  static int bytesLength() => 1;

  final int value;

  Map<String, dynamic> toJson() => {'value': value};

  Uint8List serialize() => Uint8List.fromList([value]);
}
