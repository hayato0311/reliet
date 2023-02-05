import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/extensions/string_extensions.dart';
import 'package:reliet/libs/bitcoin_lib/lib/src/protocol/types/command.dart';

void main() {
  group('create and serialize Command instance', () {
    test('of version', () {
      const commandString = 'version';
      const command = Command.version;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of verack', () {
      const commandString = 'verack';
      const command = Command.verack;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of addr', () {
      const commandString = 'addr';
      const command = Command.addr;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of inv', () {
      const commandString = 'inv';
      const command = Command.inv;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of getdata', () {
      const commandString = 'getdata';
      const command = Command.getdata;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of notfound', () {
      const commandString = 'notfound';
      const command = Command.notfound;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of getblocks', () {
      const commandString = 'getblocks';
      const command = Command.getblocks;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of verack', () {
      const commandString = 'verack';
      const command = Command.verack;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of getheaders', () {
      const commandString = 'getheaders';
      const command = Command.getheaders;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of tx', () {
      const commandString = 'tx';
      const command = Command.tx;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of block', () {
      const commandString = 'block';
      const command = Command.block;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of headers', () {
      const commandString = 'headers';
      const command = Command.headers;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of getaddr', () {
      const commandString = 'getaddr';
      const command = Command.getaddr;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of mempool', () {
      const commandString = 'mempool';
      const command = Command.mempool;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of checkorder', () {
      const commandString = 'checkorder';
      const command = Command.checkorder;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of submitorder', () {
      const commandString = 'submitorder';
      const command = Command.submitorder;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of reply', () {
      const commandString = 'reply';
      const command = Command.reply;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of ping', () {
      const commandString = 'ping';
      const command = Command.ping;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of pong', () {
      const commandString = 'pong';
      const command = Command.pong;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of reject', () {
      const commandString = 'reject';
      const command = Command.reject;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of filterload', () {
      const commandString = 'filterload';
      const command = Command.filterload;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of filteradd', () {
      const commandString = 'filteradd';
      const command = Command.filteradd;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of filterclear', () {
      const commandString = 'filterclear';
      const command = Command.filterclear;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of merkleblock', () {
      const commandString = 'merkleblock';
      const command = Command.merkleblock;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of alert', () {
      const commandString = 'alert';
      const command = Command.alert;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of sendheaders', () {
      const commandString = 'sendheaders';
      const command = Command.sendheaders;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of feefilter', () {
      const commandString = 'feefilter';
      const command = Command.feefilter;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of sendcmpct', () {
      const commandString = 'sendcmpct';
      const command = Command.sendcmpct;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of cmpctblock', () {
      const commandString = 'cmpctblock';
      const command = Command.cmpctblock;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of getblocktxn', () {
      const commandString = 'getblocktxn';
      const command = Command.getblocktxn;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
    test('of blocktxn', () {
      const commandString = 'blocktxn';
      const command = Command.blocktxn;
      final serializedCommand = command.serialize();

      expect(command.string, commandString);
      expect(serializedCommand, commandString.toBytes(12));
      expect(serializedCommand.length, 12);
    });
  });

  group('deserialize bytes to Command instance', () {
    test('of version', () {
      final serializedCommand = Command.version.serialize();
      expect(Command.deserialize(serializedCommand), Command.version);
    });

    test('of verack', () {
      final serializedCommand = Command.verack.serialize();
      expect(Command.deserialize(serializedCommand), Command.verack);
    });
    test('of addr', () {
      final serializedCommand = Command.addr.serialize();
      expect(Command.deserialize(serializedCommand), Command.addr);
    });
    test('of inv', () {
      final serializedCommand = Command.inv.serialize();
      expect(Command.deserialize(serializedCommand), Command.inv);
    });
    test('of getdata', () {
      final serializedCommand = Command.getdata.serialize();
      expect(Command.deserialize(serializedCommand), Command.getdata);
    });
    test('of notfound', () {
      final serializedCommand = Command.notfound.serialize();
      expect(Command.deserialize(serializedCommand), Command.notfound);
    });
    test('of getblocks', () {
      final serializedCommand = Command.getblocks.serialize();
      expect(Command.deserialize(serializedCommand), Command.getblocks);
    });
    test('of getheaders', () {
      final serializedCommand = Command.getheaders.serialize();
      expect(Command.deserialize(serializedCommand), Command.getheaders);
    });
    test('of tx', () {
      final serializedCommand = Command.tx.serialize();
      expect(Command.deserialize(serializedCommand), Command.tx);
    });
    test('of block', () {
      final serializedCommand = Command.block.serialize();
      expect(Command.deserialize(serializedCommand), Command.block);
    });
    test('of headers', () {
      final serializedCommand = Command.headers.serialize();
      expect(Command.deserialize(serializedCommand), Command.headers);
    });
    test('of getaddr', () {
      final serializedCommand = Command.getaddr.serialize();
      expect(Command.deserialize(serializedCommand), Command.getaddr);
    });
    test('of mempool', () {
      final serializedCommand = Command.mempool.serialize();
      expect(Command.deserialize(serializedCommand), Command.mempool);
    });
    test('of checkorder', () {
      final serializedCommand = Command.checkorder.serialize();
      expect(Command.deserialize(serializedCommand), Command.checkorder);
    });
    test('of submitorder', () {
      final serializedCommand = Command.submitorder.serialize();
      expect(Command.deserialize(serializedCommand), Command.submitorder);
    });
    test('of reply', () {
      final serializedCommand = Command.reply.serialize();
      expect(Command.deserialize(serializedCommand), Command.reply);
    });
    test('of ping', () {
      final serializedCommand = Command.ping.serialize();
      expect(Command.deserialize(serializedCommand), Command.ping);
    });
    test('of pong', () {
      final serializedCommand = Command.pong.serialize();
      expect(Command.deserialize(serializedCommand), Command.pong);
    });
    test('of reject', () {
      final serializedCommand = Command.reject.serialize();
      expect(Command.deserialize(serializedCommand), Command.reject);
    });
    test('of filterload', () {
      final serializedCommand = Command.filterload.serialize();
      expect(Command.deserialize(serializedCommand), Command.filterload);
    });
    test('of filteradd', () {
      final serializedCommand = Command.filteradd.serialize();
      expect(Command.deserialize(serializedCommand), Command.filteradd);
    });
    test('of filterclear', () {
      final serializedCommand = Command.filterclear.serialize();
      expect(Command.deserialize(serializedCommand), Command.filterclear);
    });
    test('of merkleblock', () {
      final serializedCommand = Command.merkleblock.serialize();
      expect(Command.deserialize(serializedCommand), Command.merkleblock);
    });
    test('of alert', () {
      final serializedCommand = Command.alert.serialize();
      expect(Command.deserialize(serializedCommand), Command.alert);
    });
    test('of sendheaders', () {
      final serializedCommand = Command.sendheaders.serialize();
      expect(Command.deserialize(serializedCommand), Command.sendheaders);
    });
    test('of feefilter', () {
      final serializedCommand = Command.feefilter.serialize();
      expect(Command.deserialize(serializedCommand), Command.feefilter);
    });
    test('of sendcmpct', () {
      final serializedCommand = Command.sendcmpct.serialize();
      expect(Command.deserialize(serializedCommand), Command.sendcmpct);
    });
    test('of cmpctblock', () {
      final serializedCommand = Command.cmpctblock.serialize();
      expect(Command.deserialize(serializedCommand), Command.cmpctblock);
    });
    test('of getblocktxn', () {
      final serializedCommand = Command.getblocktxn.serialize();
      expect(Command.deserialize(serializedCommand), Command.getblocktxn);
    });
    test('of blocktxn', () {
      final serializedCommand = Command.blocktxn.serialize();
      expect(Command.deserialize(serializedCommand), Command.blocktxn);
    });
    test('with invalid bytes', () {
      final bytes = Uint8List.fromList(utf8.encode('invalid'));

      expect(() => Command.deserialize(bytes), throwsArgumentError);
    });
  });
}
