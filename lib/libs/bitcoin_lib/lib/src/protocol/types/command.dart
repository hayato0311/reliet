import 'dart:typed_data';

import '../../utils/encode.dart';

enum Command {
  version("version");

  final String value;

  const Command(this.value);

  Uint8List serialize() => stringBytes(value, 12);
}
