// import 'dart:typed_data';

// import 'package:meta/meta.dart';

// import '../types/block_header.dart';
// import '../types/partial_merkle_tree.dart';
// import '../types/var_int.dart';

// @immutable
// class MerkleBlockMessage {
//   const MerkleBlockMessage._internal(
//     this.header,
//     this.partialMerkleTree,
//     this.flagsLength,
//     this.flags,
//   );

//   factory MerkleBlockMessage.deserialize(Uint8List bytes) {
//     var startIndex = 0;
//     final header = BlockHeader.deserialize(
//       bytes.sublist(
//         startIndex,
//         startIndex + BlockHeader.bytesLength(),
//       ),
//     );
//     startIndex += BlockHeader.bytesLength();

//     final partialMerkleTree = PartialMerkleTree.deserialize(
//       bytes.sublist(startIndex),
//     );
//     startIndex += partialMerkleTree.bytesLength();

//     final flagsLength = VarInt.deserialize(
//       bytes.sublist(startIndex),
//     );
//     startIndex += flagsLength.bytesLength();

//     final flags = bytes
//         .sublist(startIndex, startIndex + flagsLength.value)
//         .reversed
//         .toList();

//     return MerkleBlockMessage._internal(
//       header,
//       partialMerkleTree,
//       flagsLength,
//       flags,
//     );
//   }

//   final BlockHeader header;
//   final PartialMerkleTree partialMerkleTree;
//   final VarInt flagsLength;
//   final List<int> flags;

//   int bytesLength() {
//     return BlockHeader.bytesLength() +
//         partialMerkleTree.bytesLength() +
//         flagsLength.bytesLength() +
//         flags.length;
//   }

//   Map<String, dynamic> toJson() => {
//         'header': header.toJson(),
//         'partialMerkleTree': partialMerkleTree.toJson(),
//         'flagsLength': flagsLength.toJson(),
//         'flags': flags
//       };
// }
