import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../extensions/int_extensions.dart';

// TODO: inherit from Uint32le
@immutable
class BlockVersion {
  const BlockVersion(this.value);

  factory BlockVersion.deserialize(Uint8List bytes) =>
      BlockVersion(CreateInt.fromUint32leBytes(bytes));

  static int bytesLength() => 4;

  final int value;

  Map<String, dynamic> toJson() => {'value': value};

  Uint8List serialize() => value.toUint32leBytes();
}
