import 'dart:typed_data';

import '../../extensions/string_extensions.dart';

enum Command {
  version('version');

  const Command(this.string);

  factory Command.deserialize(Uint8List bytes) {
    final commandValue = CreateString.fromBytes(bytes);

    if (commandValue == 'version') {
      return Command.version;
    } else {
      throw ArgumentError('Undefined command');
    }
  }

  static int bytesLength() => 12;

  final String string;

  Map<String, dynamic> toJson() => {'string': "${toString()}('$string')"};

  Uint8List serialize() => string.toBytes(12);
}
