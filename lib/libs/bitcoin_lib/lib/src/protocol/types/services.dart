import 'dart:typed_data';

import '../../extensions/int_extensions.dart';
import 'service.dart';

class Services {
  factory Services(List<Service> serviceList) {
    if (serviceList.isEmpty) {
      throw const FormatException('Services is empty');
    }
    if (serviceList.length != serviceList.toSet().length) {
      throw const FormatException('Services should only have unique elements');
    }

    return Services._internal(serviceList);
  }

  Services._internal(this.serviceList);

  final List<Service> serviceList;

  Uint8List serialize() {
    final value =
        serviceList.map((service) => service.value).reduce((v, e) => v + e);

    return value.toUint64leBytes();
  }
}
