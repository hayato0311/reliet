import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../extensions/int_extensions.dart';
import 'service.dart';

@immutable
class ServiceFlags {
  factory ServiceFlags(List<ServiceFlag> serviceList) {
    if (serviceList.isEmpty) {
      throw const FormatException('serviceList is empty');
    }
    if (serviceList.length != serviceList.toSet().length) {
      throw const FormatException(
        'serviceList should only have unique elements',
      );
    }

    return ServiceFlags._internal(serviceList);
  }

  factory ServiceFlags.deserialize(Uint8List bytes) {
    var servicesValueSum = CreateInt.fromUint64leBytes(bytes);
    var serviceList = <ServiceFlag>[];

    if (servicesValueSum == 0) {
      serviceList += [ServiceFlag.nodeZero];
    }

    if (servicesValueSum >= 1024) {
      serviceList += [ServiceFlag.nodeNetworkLimited];
      servicesValueSum -= 1024;
    }
    if (servicesValueSum >= 64) {
      serviceList += [ServiceFlag.nodeCompactFilters];
      servicesValueSum -= 64;
    }
    if (servicesValueSum >= 16) {
      serviceList += [ServiceFlag.nodeXthin];
      servicesValueSum -= 16;
    }
    if (servicesValueSum >= 8) {
      serviceList += [ServiceFlag.nodeWitness];
      servicesValueSum -= 8;
    }
    if (servicesValueSum >= 4) {
      serviceList += [ServiceFlag.nodeBloom];
      servicesValueSum -= 4;
    }
    if (servicesValueSum >= 2) {
      serviceList += [ServiceFlag.nodeGetutxo];
      servicesValueSum -= 2;
    }
    if (servicesValueSum >= 1) {
      serviceList += [ServiceFlag.nodeNetwork];
      servicesValueSum -= 1;
    }

    if (servicesValueSum != 0) {
      throw ArgumentError('Invalid ServiceFlags bytes');
    }

    return ServiceFlags(serviceList);
  }

  const ServiceFlags._internal(this.serviceList);

  static int bytesLength() => 8;

  final List<ServiceFlag> serviceList;

  Map<String, dynamic> toJson() => {
        'serviceList': [
          for (ServiceFlag service in serviceList)
            '${service.toString()}(${service.value})'
        ]
      };

  Uint8List serialize() {
    final value =
        serviceList.map((service) => service.value).reduce((v, e) => v + e);

    return value.toUint64leBytes();
  }
}
