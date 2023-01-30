import 'dart:typed_data';

import '../../utils/encode.dart';

enum Command {
  version('version');

  const Command(this.value);

  final String value;

  Uint8List serialize() => stringBytes(value, 12);
}
