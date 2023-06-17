import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../types/bases/uint32le.dart';
import '../types/bloom_filter.dart';
import '../types/var_bytes.dart';

@immutable
class FilterLoadMessage {
  factory FilterLoadMessage({
    required VarBytes filter,
    required Uint32le nHashFuncs,
    required Uint32le nTweak,
    required BloomFlag nFlags,
  }) {
    final bloomFilter = BloomFilter(
      nHashFuncs: nHashFuncs,
      nTweak: nTweak,
      data: filter,
      nFlags: nFlags,
    );
    return FilterLoadMessage._internal(
      filter,
      nHashFuncs,
      nTweak,
      nFlags,
      bloomFilter,
    );
  }

  factory FilterLoadMessage.create({
    required Uint32le nElements,
    required double nFPRate,
    required Uint32le nTweak,
    required BloomFlag nFlags,
  }) {
    final bloomFilter = BloomFilter.create(
      nElements: nElements,
      nFPRate: nFPRate,
      nTweak: nTweak,
      nFlags: nFlags,
    );
    return FilterLoadMessage._internal(
      bloomFilter.data,
      bloomFilter.nHashFuncs,
      nTweak,
      nFlags,
      bloomFilter,
    );
  }

  const FilterLoadMessage._internal(
    this.filter,
    this.nHashFuncs,
    this.nTweak,
    this.nFlags,
    this.bloomFilter,
  );

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
  final BloomFilter bloomFilter;

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
