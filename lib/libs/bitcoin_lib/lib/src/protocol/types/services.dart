import 'dart:typed_data';

import '../../extensions/int_extensions.dart';
import 'service.dart';

class Services {
  factory Services(List<Service> serviceList) {
    if (serviceList.isEmpty) {
      throw const FormatException('serviceList is empty');
    }
    if (serviceList.length != serviceList.toSet().length) {
      throw const FormatException(
        'serviceList should only have unique elements',
      );
    }

    return Services._internal(serviceList);
  }
  factory Services.deserialize(Uint8List bytes) {
    var servicesValueSum = CreateInt.fromUint64leBytes(bytes);
    var serviceList = <Service>[];

    if (servicesValueSum == 0) {
      throw ArgumentError('No Services are included in the given bytes');
    }

    if (servicesValueSum >= 1024) {
      serviceList += [Service.nodeNetworkLimited];
      servicesValueSum -= 1024;
    }
    if (servicesValueSum >= 64) {
      serviceList += [Service.nodeCompactFilters];
      servicesValueSum -= 64;
    }
    if (servicesValueSum >= 16) {
      serviceList += [Service.nodeXthin];
      servicesValueSum -= 16;
    }
    if (servicesValueSum >= 8) {
      serviceList += [Service.nodeWitness];
      servicesValueSum -= 8;
    }
    if (servicesValueSum >= 4) {
      serviceList += [Service.nodeBloom];
      servicesValueSum -= 4;
    }
    if (servicesValueSum >= 2) {
      serviceList += [Service.nodeGetutxo];
      servicesValueSum -= 2;
    }
    if (servicesValueSum >= 1) {
      serviceList += [Service.nodeNetwork];
      servicesValueSum -= 1;
    }

    if (servicesValueSum != 0) {
      throw ArgumentError('Invalid Services bytes');
    }

    return Services(serviceList);
  }
  Services._internal(this.serviceList);

  final List<Service> serviceList;

  Uint8List serialize() {
    final value =
        serviceList.map((service) => service.value).reduce((v, e) => v + e);

    return value.toUint64leBytes();
  }
}
