// Source: https://github.com/bitcoin/bitcoin/blob/master/src/chainparams.cpp

class MainParams {
  static const List<String> dnsSeeds = [
    'seed.bitcoin.sipa.be',
    'dnsseed.bluematt.me',
    'dnsseed.bitcoin.dashjr.org',
    'seed.bitcoinstats.com',
    'seed.bitcoin.jonasschnelli.ch',
    'seed.btc.petertodd.org',
    'seed.bitcoin.sprovoost.nl',
    'dnsseed.emzy.de',
    'seed.bitcoin.wiz.biz',
  ];
}

class TestnetParams {
  static const List<String> dnsSeeds = [
    'testnet-seed.bitcoin.jonasschnelli.ch',
    'testnet-seed.bluematt.me',
  ];
}
