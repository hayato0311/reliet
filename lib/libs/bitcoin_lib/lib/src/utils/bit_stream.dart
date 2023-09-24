class BitStream {
  BitStream(this.value);

  BigInt value;
  int numTopZeroBits = 0;

  BigInt read(int numBits) {
    var numBitsToRead = numBits;

    if (numTopZeroBits >= 1) {
      if (numTopZeroBits >= numBits) {
        numTopZeroBits -= numBits;
        return BigInt.zero;
      } else {
        numBitsToRead -= numTopZeroBits;
        numTopZeroBits = 0;
      }
    }

    if (value.bitLength < numBitsToRead) {
      print('value.bitLength: ${value.bitLength}');
      print('numBitsToRead: $numBitsToRead');
      // throw Exception('Not enough bits to read');
      return BigInt.zero;
    }

    final topBits = value >> (value.bitLength - numBitsToRead);

    final excludedTopBitsMask =
        (BigInt.one << (value.bitLength - numBitsToRead)) - BigInt.one;

    final prevValue = value;
    value = value & excludedTopBitsMask;
    numTopZeroBits = (prevValue.bitLength - numBitsToRead) - value.bitLength;

    return topBits;
  }

  void write(BigInt bitsToWrite, int numBits) {
    if (bitsToWrite.bitLength > numBits) {
      throw Exception('Number of bits in bitsToWrite exceeds numBits');
    }

    // Shift the current value to make room for the new bits
    value <<= numBits;

    // OR the new bits onto the value
    value |= bitsToWrite;

    // Update the numTopZeroBits
    if (bitsToWrite == BigInt.zero && value == BigInt.zero) {
      numTopZeroBits += numBits;
    }
  }
}
