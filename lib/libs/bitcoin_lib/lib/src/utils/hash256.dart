import 'package:crypto/crypto.dart';

Digest hash256(List<int> bytes) {
  final digest = sha256.convert(bytes);
  return sha256.convert(digest.bytes);
}
