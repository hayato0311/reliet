import 'dart:typed_data';

import '../../utils/encode.dart';
import 'service.dart';

class Services {
  final int value;

  Services._internal(this.value);

  factory Services(List<Service> services) {
    if (services.isEmpty) {
      throw const FormatException("Services is empty");
    }
    if (services.length != services.toSet().length) {
      throw const FormatException("Services should only have unique elements");
    }

    final int value = services
        .map((Service service) => service.value)
        .reduce((v, e) => v + e);

    return Services._internal(value);
  }

  Uint8List serialize() => uint64leBytes(value);
}
