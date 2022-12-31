// import 'dart:io';

// void main() async {
//   final socket = await Socket.connect(
//     'testnet-seed.bitcoin.jonasschnelli.ch',
//     18333,
//   );
//   print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
// }

// // import 'dart:convert';

// // import 'package:crypto/crypto.dart';

// // Digest hash256(List<int> input) {
// //   final Digest digest = sha256.convert(input);

// //   return sha256.convert(utf8.encode(digest.toString()));
// // }

// // void main() async {
// //   var bytes1 = utf8.encode('aab');
// //   var digest1 = sha256.convert(bytes1);
// //   print('SHA-256 : ${digest1.toString()}');
// //   print('HASH-256 : ${hash256(bytes1)}');
// // }

import 'package:reliet/libs/bitcoin_lib/lib/src/handshake.dart';

void main() {
  handshake();
}

// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:reliet/libs/bitcoin_lib/lib/src/encode.dart';

// void main() {
//   var bdata = ByteData(8);
//   bdata.setUint16(0, 300);
//   var test = Uint8List(4)..buffer.asByteData().setInt32(0, 500, Endian.big);
//   print(test);
//   print(bdata.getUint16(0, Endian.big));
//   final tmp = Uint8List.fromList([]);
//   print(tmp);
//   print(tmp.toList());
//   print(Endian.host == Endian.little);

//   List<List<int>> myByteLists = [[]];
//   myByteLists[0].addAll(Uint8List.fromList([10]).toList());
//   print(myByteLists);
//   print(utf8.encode("hello"));
//   var hello = utf8.encode("hello").toList();
//   hello.insertAll(0, List.generate(8 - hello.length, (i) => 0));
//   print(hello);
//   print(List.from(utf8.encode("hello")));
//   print(char64beBytes("hello"));
//   print(List.from(utf8.encode("hello").reversed));
//   print(char64leBytes("hello"));
// }
