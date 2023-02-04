import 'dart:typed_data';

import '../../extensions/string_extensions.dart';

enum Command {
  version('version');

  const Command(this.value);

  factory Command.deserialize(Uint8List bytes) {
    final commandValue = CreateString.fromBytes(bytes);

    if (commandValue == 'version') {
      return Command.version;
    } else {
      throw ArgumentError('Undefined command');
    }
  }

  static int bytesLength() => 12;

  final String value;

  Uint8List serialize() => value.toBytes(12);
}
