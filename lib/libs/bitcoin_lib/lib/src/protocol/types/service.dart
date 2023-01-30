enum Service {
  nodeZero(0),
  nodeNetwork(1),
  nodeGetutxo(2),
  nodeBloom(4),
  nodeWitness(8),
  nodeXthin(16),
  nodeCompactFilters(64),
  nodeNetworkLimited(1024);

  const Service(this.value);
  final int value;
}
