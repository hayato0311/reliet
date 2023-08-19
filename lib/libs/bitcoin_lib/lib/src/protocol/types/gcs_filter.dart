import 'dart:typed_data';

import '../../extensions/big_int_extensions.dart';
import '../../extensions/uint8_list_extensions.dart';
import 'sip_hash.dart';

const m = 784931;
const p = 19;

final mask = BigInt.parse('0xFFFFFFFFFFFFFFFF');

bool gcsMatch(
  Uint8List key,
  Uint8List compressedSet,
  Uint8List target,
  int numItems,
) {
  if (key.length != 16) {
    throw ArgumentError('Key must be 16 bytes');
  }

  final f = BigInt.from(numItems) * BigInt.from(m) & mask;
  final targetHash = hashToRange(target, f, key);

  var lastValue = Uint8List(0);

  for (var i = 0; i < numItems; i++) {
    final delta = golombDecode(compressedSet);
    final setItem = Uint8List.fromList(lastValue + delta);

    if (setItem == targetHash) {
      return true;
    }

    // Since the values in the set are sorted, terminate the search once
    // the decoded value exceeds the target.
    if (BigInt.parse(setItem.toHex()) > BigInt.parse(targetHash.toHex())) {
      break;
    }

    lastValue = setItem;
  }
  return false;
}

Uint8List golombDecode(Uint8List data) {
  var q = 0;
  while (data[q] == 1) {
    q++;
  }
  final r = data.sublist(q, p);

  final x = ((BigInt.from(q) << p) & mask) + BigInt.parse(r.toHex());

  return x.toUint8List();
}

Uint8List hashToRange(Uint8List item, BigInt f, Uint8List key) {
  final hash = SipHash(key: key, data: item).bytes;
  final multipliedHash = (BigInt.parse(hash.toHex()) * (f & mask)) & mask;
  return (multipliedHash >> 64).toUint8List();
}
