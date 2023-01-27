import 'package:crypto/crypto.dart';

Digest hash256(List<int> input) {
  final Digest digest = sha256.convert(input);

  return sha256.convert(digest.bytes);
}
