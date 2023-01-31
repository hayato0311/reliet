import 'dart:typed_data';

import '../../extensions/int_extensions.dart';
import 'service.dart';

class Services {
  factory Services(List<Service> services) {
    if (services.isEmpty) {
      throw const FormatException('Services is empty');
    }
    if (services.length != services.toSet().length) {
      throw const FormatException('Services should only have unique elements');
    }

    final value =
        services.map((service) => service.value).reduce((v, e) => v + e);

    return Services._internal(value);
  }

  Services._internal(this.value);
  final int value;

  Uint8List serialize() => value.toUint64leBytes();
}
