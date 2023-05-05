import 'dart:typed_data';

import '../../extensions/string_extensions.dart';

enum Command {
  version('version'),
  verack('verack'),
  addr('addr'),
  inv('inv'),
  getdata('getdata'),
  notfound('notfound'),
  getblocks('getblocks'),
  getheaders('getheaders'),
  tx('tx'),
  block('block'),
  headers('headers'),
  getaddr('getaddr'),
  mempool('mempool'),
  checkorder('checkorder'),
  submitorder('submitorder'),
  reply('reply'),
  ping('ping'),
  pong('pong'),
  reject('reject'),
  filterload('filterload'),
  filteradd('filteradd'),
  filterclear('filterclear'),
  merkleblock('merkleblock'),
  alert('alert'),
  sendheaders('sendheaders'),
  feefilter('feefilter'),
  sendcmpct('sendcmpct'),
  cmpctblock('cmpctblock'),
  getblocktxn('getblocktxn'),
  blocktxn('blocktxn');

  const Command(this.string);

  factory Command.deserialize(Uint8List bytes) {
    final commandValue = CreateString.fromBytes(bytes);

    switch (commandValue) {
      case 'version':
        return Command.version;

      case 'verack':
        return Command.verack;

      case 'addr':
        return Command.addr;

      case 'inv':
        return Command.inv;

      case 'getdata':
        return Command.getdata;

      case 'notfound':
        return Command.notfound;

      case 'getblocks':
        return Command.getblocks;

      case 'getheaders':
        return Command.getheaders;

      case 'tx':
        return Command.tx;

      case 'block':
        return Command.block;

      case 'headers':
        return Command.headers;

      case 'getaddr':
        return Command.getaddr;

      case 'mempool':
        return Command.mempool;

      case 'checkorder':
        return Command.checkorder;

      case 'submitorder':
        return Command.submitorder;

      case 'reply':
        return Command.reply;

      case 'ping':
        return Command.ping;

      case 'pong':
        return Command.pong;

      case 'reject':
        return Command.reject;

      case 'filterload':
        return Command.filterload;

      case 'filteradd':
        return Command.filteradd;

      case 'filterclear':
        return Command.filterclear;

      case 'merkleblock':
        return Command.merkleblock;

      case 'alert':
        return Command.alert;

      case 'sendheaders':
        return Command.sendheaders;

      case 'feefilter':
        return Command.feefilter;

      case 'sendcmpct':
        return Command.sendcmpct;

      case 'cmpctblock':
        return Command.cmpctblock;

      case 'getblocktxn':
        return Command.getblocktxn;

      case 'blocktxn':
        return Command.blocktxn;
    }

    throw ArgumentError('Command "$commandValue" is undefined');
  }

  static int bytesLength() => 12;

  final String string;

  Map<String, dynamic> toJson() => {'string': "${toString()}('$string')"};

  Uint8List serialize() => string.encodeAsUtf8(12);
}
