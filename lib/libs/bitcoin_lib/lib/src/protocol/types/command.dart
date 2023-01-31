import 'dart:typed_data';

import '../../extensions/string_extensions.dart';

enum Command {
  version('version');

  const Command(this.value);

  final String value;

  Uint8List serialize() => value.toBytes(12);
}
