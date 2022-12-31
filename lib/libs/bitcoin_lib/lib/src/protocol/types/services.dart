class Services {
  late final int value;
  late final String name;

  Services({
    bool nodeNetwork = false,
    bool nodeGetutxo = false,
    bool nodeBloom = false,
    bool nodeWitness = false,
    bool nodeXthin = false,
    bool nodeCompactFilters = false,
    bool nodeNetworkLimited = false,
  }) {
    if (nodeNetwork) {
      value = 1;
      name = "NODE_NETWORK";
      // This node can be asked for full blocks instead of just headers.
    } else if (nodeGetutxo) {
      value = 2;
      name = "NODE_GETUTXO";
      // BIP 0064
    } else if (nodeBloom) {
      value = 4;
      name = "NODE_BLOOM";
      // BIP 0111
    } else if (nodeWitness) {
      value = 8;
      name = "NODE_WITNESS";
      // BIP 0144
    } else if (nodeXthin) {
      value = 16;
      name = "NODE_XTHIN";
      // Never formally proposed (as a BIP), and discontinued. Was historically sporadically seen on the network.
    } else if (nodeCompactFilters) {
      value = 64;
      name = "NODE_COMPACT_FILTERS";
      // BIP 0157
    } else if (nodeNetworkLimited) {
      value = 1024;
      name = "NODE_NETWORK_LIMITED";
      // BIP 0159
    } else {
      throw Exception("must select a service");
    }
  }
}
