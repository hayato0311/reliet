import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/uint8_list_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/gcs_filter.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/op_code.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/script.dart';

// import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/var_bytes.dart';

import 'data/block700000_block_message.dart';
import 'data/block700000_cfilters_message.dart';

void main() {
  group('create filter', () {
    // test('with sample data', () {
    //   // このテストはなくていいかも
    //   // 多分答えないから
    //   final key = Uint8List.fromList(List.filled(16, 1));
    //   final items = List.filled(5, Uint8List(0));

    //   // First two are outputs on a single transaction.
    //   items[0] = Uint8List.fromList(
    //     [...List.filled(65, 0), OpCode.opCheckSig.value],
    //   );
    //   items[1] = Uint8List.fromList([
    //     OpCode.opDup.value,
    //     OpCode.opHash160.value,
    //     ...List.filled(20, 0),
    //     OpCode.opEqualVerify.value,
    //     OpCode.opCheckSig.value
    //   ]);

    //   // Third is an output on in a second transaction.
    //   items[2] = Uint8List.fromList([
    //     OpCode.opPushNum1.value,
    //     ...List.filled(33, 2),
    //     OpCode.opPushNum1.value,
    //     OpCode.opCheckMultiSig.value
    //   ]);

    //   // Last two are spent by a single transaction.
    //   items[3] = Uint8List.fromList([
    //     OpCode.opPushBytes0.value,
    //     ...List.filled(32, 3),
    //   ]);
    //   items[4] = Uint8List.fromList([
    //     OpCode.opPushNum4.value,
    //     OpCode.opAdd.value,
    //     OpCode.opPushNum8.value,
    //     OpCode.opEqual.value,
    //   ]);

    //   final gcsFilter = createGcsFilter(key, items);

    //   // expect(
    //   //   gcsFilter.bitStream.value,
    //   //   'ここはいい感じに頑張って探す',
    //   // );
    // });

    test('with on chain data', () {
      // use Bitcoin Block 700,000
      print(
        Uint8List.fromList(blockMessageOf700000.previousBlockHash.bytes)
            .toHex(),
      );
      final gcsFilter = GcsFilter();
      final key = Uint8List.fromList(
        cFiltersMessageOfBlock700000.blockHash.bytes.sublist(0, 16),
      );

      // ここのitemsには、blockMessageOf700000のtxsのデータをあれこれ入れる。
      final items = <Uint8List>[];

      // ここでtxsのデータをitemsに入れる
      for (final tx in blockMessageOf700000.txs) {
        // for (final txIn in tx.txIns) {
        //   if (txIn.isCoinBase()) continue;
        //   //TODO: ここは、txInのpreviousOutputではなく、previousOutputのscriptPubkeyを入れる必要がある。
        //   items.add(txIn.previousOutput.serialize());
        // }
        for (final txOut in tx.txOuts) {
          if (txOut.empty() ||
              txOut.scriptPubkey.commands[0] == OpCode.opReturn) {
            continue;
          }

          items.add(Script.serializeCommands(txOut.scriptPubkey.commands));
        }
      }
      // gcsFilter.createFilter(key, items);
      // expect(
      //   gcsFilter.bitStream.value,
      //   BigInt.parse(cFiltersMessageOfBlock700000.filterBytes.bytes.toHex()),
      // );
    });
  });
  // group('check if contain the target item in the filter', () {
  //   group('with sample data', () {
  //     final key = Uint8List.fromList(List.filled(16, 1));
  //     final items = List.filled(5, Uint8List(0));

  //     // First two are outputs on a single transaction.
  //     items[0] = Uint8List.fromList(
  //       [...List.filled(65, 0), OpCode.opCheckSig.value],
  //     );
  //     items[1] = Uint8List.fromList([
  //       OpCode.opDup.value,
  //       OpCode.opHash160.value,
  //       ...List.filled(20, 0),
  //       OpCode.opEqualVerify.value,
  //       OpCode.opCheckSig.value
  //     ]);

  //     // Third is an output on in a second transaction.
  //     items[2] = Uint8List.fromList([
  //       OpCode.opPushNum1.value,
  //       ...List.filled(33, 2),
  //       OpCode.opPushNum1.value,
  //       OpCode.opCheckMultiSig.value
  //     ]);

  //     // Last two are spent by a single transaction.
  //     items[3] = Uint8List.fromList([
  //       OpCode.opPushBytes0.value,
  //       ...List.filled(32, 3),
  //     ]);
  //     items[4] = Uint8List.fromList([
  //       OpCode.opPushNum4.value,
  //       OpCode.opAdd.value,
  //       OpCode.opPushNum8.value,
  //       OpCode.opEqual.value,
  //     ]);

  //     final gcsFilter = createGcsFilter(key, items);

  //     final compressedSet = VarBytes.fromBigInt(gcsFilter);
  //     final target = Uint8List.fromList([1, 2, 3]);
  //     const numItems = 3;

  //     test('the filter should contain the target item', () {
  //       expect(
  //         gcsMatch(key, compressedSet, target, numItems),
  //         true,
  //       );
  //     });
  //     test('the filter should not contain the target item', () {
  //       expect(
  //         gcsMatch(key, compressedSet, target, numItems),
  //         false,
  //       );
  //     });
  //   });

  //   group('with on chain data', () {
  //     final gcsFilter = GcsFilter();
  //     final key = Uint8List.fromList(List.filled(16, 1));
  //     final compressedSet = VarBytes(Uint8List.fromList([1, 2, 3]));
  //     final target = Uint8List.fromList([1, 2, 3]);
  //     const numItems = 3;

  //     test('the filter should contain the target item', () {
  //       expect(
  //         gcsFilter.gcsMatch(key, compressedSet, target, numItems),
  //         true,
  //       );
  //     });

  //     test('the filter should not contain the target item', () {
  //       expect(
  //         gcsFilter.gcsMatch(key, compressedSet, target, numItems),
  //         false,
  //       );
  //     });
  //   });
  // });
}
