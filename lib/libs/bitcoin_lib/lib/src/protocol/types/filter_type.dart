import 'dart:typed_data';

enum FilterType {
  basic(0);

  const FilterType(this.value);

  static FilterType deserialize(Uint8List bytes) {
    final value = bytes[0];
    switch (value) {
      case 0:
        return FilterType.basic;
      default:
        throw Exception('Invalid BloomFlag value: $value');
    }
  }

  static int bytesLength() => 1;

  final int value;

  Map<String, dynamic> toJson() => {'value': value};

  Uint8List serialize() => Uint8List.fromList([value]);
}
