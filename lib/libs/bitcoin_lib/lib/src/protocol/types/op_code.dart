import 'dart:typed_data';

import '../../extensions/int_extensions.dart';

enum OpCode {
  // Push an empty array onto the stack.
  opPushBytes0._internal(0),

  // Push the next byte as an array onto the stack.
  opPushBytes1._internal(1),

  // Push the next 2 bytes as an array onto the stack.
  opPushBytes2._internal(2),

  // Push the next 3 bytes as an array onto the stack.
  opPushBytes3._internal(3),

  // Push the next 4 bytes as an array onto the stack.
  opPushBytes4._internal(4),

  // Push the next 5 bytes as an array onto the stack.
  opPushBytes5._internal(5),

  // Push the next 6 bytes as an array onto the stack.
  opPushBytes6._internal(6),

  // Push the next 7 bytes as an array onto the stack.
  opPushBytes7._internal(7),

  // Push the next 8 bytes as an array onto the stack.
  opPushBytes8._internal(8),

  // Push the next 9 bytes as an array onto the stack.
  opPushBytes9._internal(9),

  // Push the next 10 bytes as an array onto the stack.
  opPushBytes10._internal(10),

  // Push the next 11 bytes as an array onto the stack.
  opPushBytes11._internal(11),

  // Push the next 12 bytes as an array onto the stack.
  opPushBytes12._internal(12),

  // Push the next 13 bytes as an array onto the stack.
  opPushBytes13._internal(13),

  // Push the next 14 bytes as an array onto the stack.
  opPushBytes14._internal(14),

  // Push the next 15 bytes as an array onto the stack.
  opPushBytes15._internal(15),

  // Push the next 16 bytes as an array onto the stack.
  opPushBytes16._internal(16),

  // Push the next 17 bytes as an array onto the stack.
  opPushBytes17._internal(17),

  // Push the next 18 bytes as an array onto the stack.
  opPushBytes18._internal(18),

  // Push the next 19 bytes as an array onto the stack.
  opPushBytes19._internal(19),

  // Push the next 20 bytes as an array onto the stack.
  opPushBytes20._internal(20),

  // Push the next 21 bytes as an array onto the stack.
  opPushBytes21._internal(21),

  // Push the next 22 bytes as an array onto the stack.
  opPushBytes22._internal(22),

  // Push the next 23 bytes as an array onto the stack.
  opPushBytes23._internal(23),

  // Push the next 24 bytes as an array onto the stack.
  opPushBytes24._internal(24),

  // Push the next 25 bytes as an array onto the stack.
  opPushBytes25._internal(25),

  // Push the next 26 bytes as an array onto the stack.
  opPushBytes26._internal(26),

  // Push the next 27 bytes as an array onto the stack.
  opPushBytes27._internal(27),

  // Push the next 28 bytes as an array onto the stack.
  opPushBytes28._internal(28),

  // Push the next 29 bytes as an array onto the stack.
  opPushBytes29._internal(29),

  // Push the next 30 bytes as an array onto the stack.
  opPushBytes30._internal(30),

  // Push the next 31 bytes as an array onto the stack.
  opPushBytes31._internal(31),

  // Push the next 32 bytes as an array onto the stack.
  opPushBytes32._internal(32),

  // Push the next 33 bytes as an array onto the stack.
  opPushBytes33._internal(33),

  // Push the next 34 bytes as an array onto the stack.
  opPushBytes34._internal(34),

  // Push the next 35 bytes as an array onto the stack.
  opPushBytes35._internal(35),

  // Push the next 36 bytes as an array onto the stack.
  opPushBytes36._internal(36),

  // Push the next 37 bytes as an array onto the stack.
  opPushBytes37._internal(37),

  // Push the next 38 bytes as an array onto the stack.
  opPushBytes38._internal(38),

  // Push the next 39 bytes as an array onto the stack.
  opPushBytes39._internal(39),

  // Push the next 40 bytes as an array onto the stack.
  opPushBytes40._internal(40),

  // Push the next 41 bytes as an array onto the stack.
  opPushBytes41._internal(41),

  // Push the next 42 bytes as an array onto the stack.
  opPushBytes42._internal(42),

  // Push the next 43 bytes as an array onto the stack.
  opPushBytes43._internal(43),

  // Push the next 44 bytes as an array onto the stack.
  opPushBytes44._internal(44),

  // Push the next 45 bytes as an array onto the stack.
  opPushBytes45._internal(45),

  // Push the next 46 bytes as an array onto the stack.
  opPushBytes46._internal(46),

  // Push the next 47 bytes as an array onto the stack.
  opPushBytes47._internal(47),

  // Push the next 48 bytes as an array onto the stack.
  opPushBytes48._internal(48),

  // Push the next 49 bytes as an array onto the stack.
  opPushBytes49._internal(49),

  // Push the next 50 bytes as an array onto the stack.
  opPushBytes50._internal(50),

  // Push the next 51 bytes as an array onto the stack.
  opPushBytes51._internal(51),

  // Push the next 52 bytes as an array onto the stack.
  opPushBytes52._internal(52),

  // Push the next 53 bytes as an array onto the stack.
  opPushBytes53._internal(53),

  // Push the next 54 bytes as an array onto the stack.
  opPushBytes54._internal(54),

  // Push the next 55 bytes as an array onto the stack.
  opPushBytes55._internal(55),

  // Push the next 56 bytes as an array onto the stack.
  opPushBytes56._internal(56),

  // Push the next 57 bytes as an array onto the stack.
  opPushBytes57._internal(57),

  // Push the next 58 bytes as an array onto the stack.
  opPushBytes58._internal(58),

  // Push the next 59 bytes as an array onto the stack.
  opPushBytes59._internal(59),

  // Push the next 60 bytes as an array onto the stack.
  opPushBytes60._internal(60),

  // Push the next 61 bytes as an array onto the stack.
  opPushBytes61._internal(61),

  // Push the next 62 bytes as an array onto the stack.
  opPushBytes62._internal(62),

  // Push the next 63 bytes as an array onto the stack.
  opPushBytes63._internal(63),

  // Push the next 64 bytes as an array onto the stack.
  opPushBytes64._internal(64),

  // Push the next 65 bytes as an array onto the stack.
  opPushBytes65._internal(65),

  // Push the next 66 bytes as an array onto the stack.
  opPushBytes66._internal(66),

  // Push the next 67 bytes as an array onto the stack.
  opPushBytes67._internal(67),

  // Push the next 68 bytes as an array onto the stack.
  opPushBytes68._internal(68),

  // Push the next 69 bytes as an array onto the stack.
  opPushBytes69._internal(69),

  // Push the next 70 bytes as an array onto the stack.
  opPushBytes70._internal(70),

  // Push the next 71 bytes as an array onto the stack.
  opPushBytes71._internal(71),

  // Push the next 72 bytes as an array onto the stack.
  opPushBytes72._internal(72),

  // Push the next 73 bytes as an array onto the stack.
  opPushBytes73._internal(73),

  // Push the next 74 bytes as an array onto the stack.
  opPushBytes74._internal(74),

  // Push the next 75 bytes as an array onto the stack.
  opPushBytes75._internal(75),

  // Read the next byte as N; push the next N bytes as an array onto the stack.
  opPushData1._internal(76),

  // Read the next 2 bytes as N; push the next N bytes as an array onto the stack.
  opPushData2._internal(77),

  // Read the next 4 bytes as N; push the next N bytes as an array onto the stack.
  opPushData4._internal(78),

  // Push the number -1 onto the stack.
  opPushNumNeg1._internal(79),

  // Synonym for OP_RETURN.
  opReserved._internal(80),

  // Push the number `0x01` onto the stack.
  opPushNum1._internal(81),

  // Push the number `0x02` onto the stack.
  opPushNum2._internal(82),

  // Push the number `0x03` onto the stack.
  opPushNum3._internal(83),

  // Push the number `0x04` onto the stack.
  opPushNum4._internal(84),

  // Push the number `0x05` onto the stack.
  opPushNum5._internal(85),

  // Push the number `0x06` onto the stack.
  opPushNum6._internal(86),

  // Push the number `0x07` onto the stack.
  opPushNum7._internal(87),

  // Push the number `0x08` onto the stack.
  opPushNum8._internal(88),

  // Push the number `0x09` onto the stack.
  opPushNum9._internal(89),

  // Push the number `0x0a` onto the stack.
  opPushNum10._internal(90),

  // Push the number `0x0b` onto the stack.
  opPushNum11._internal(91),

  // Push the number `0x0c` onto the stack.
  opPushNum12._internal(92),

  // Push the number `0x0d` onto the stack.
  opPushNum13._internal(93),

  // Push the number `0x0e` onto the stack.
  opPushNum14._internal(94),

  // Push the number `0x0f` onto the stack.
  opPushNum15._internal(95),

  // Push the number `0x10` onto the stack.
  opPushNum16._internal(96),

  // Does nothing.
  opNop._internal(97),

  // Synonym for OP_RETURN.
  opVer._internal(98),

  // Pop and execute the next statements if a nonzero element was popped.
  opIf._internal(99),

  // Pop and execute the next statements if a zero element was popped.
  opNotIf._internal(100),

  // Fail the script unconditionally, does not even need to be executed.
  opVerIf._internal(101),

  // Fail the script unconditionally, does not even need to be executed.
  opVerNotIf._internal(102),

  // Execute statements if those after the previous OP_IF were not, and vice-versa.
  // If there is no previous OP_IF, this acts as a RETURN.
  opElse._internal(103),

  // Pop and execute the next statements if a zero element was popped.
  opEndIf._internal(104),

  // If the top value is zero or the stack is empty, fail; otherwise, pop the stack.
  opVerify._internal(105),

  // Fail the script immediately. (Must be executed.).
  opReturn._internal(106),

  // Pop one element from the main stack onto the alt stack.
  opToAltStack._internal(107),

  // Pop one element from the alt stack onto the main stack.
  opFromAltStack._internal(108),

  // Drops the top two stack items.
  op2Drop._internal(109),

  // Duplicates the top two stack items as AB -> ABAB.
  op2Dup._internal(110),

  // Duplicates the two three stack items as ABC -> ABCABC.
  op3Dup._internal(111),

  // Copies the two stack items of items two spaces back to
  // the front, as xxAB -> ABxxAB.
  op2Over._internal(112),

  // Moves the two stack items four spaces back to the front,
  // as xxxxAB -> ABxxxx.
  op2Rot._internal(113),

  // Swaps the top two pairs of items, as ABCD -> CDAB.
  op2Swap._internal(114),

  // Duplicate the top stack element unless it is zero.
  opIfDup._internal(115),

  // Push the current number of stack items onto the stack.
  opDepth._internal(116),

  // Drops the top stack item.
  opDrop._internal(117),

  // Duplicates the top stack item.
  opDup._internal(118),

  // Drops the second-to-top stack item.
  opNip._internal(119),

  // Copies the second-to-top stack item, as xA -> AxA.
  opOver._internal(120),

  // Pop the top stack element as N. Copy the Nth stack element to the top.
  opPick._internal(121),

  // Pop the top stack element as N. Move the Nth stack element to the top.
  opRoll._internal(122),

  // Rotate the top three stack items, as [top next1 next2] -> [next2 top next1].
  opRot._internal(123),

  // Swap the top two stack items.
  opSwap._internal(124),

  // Copy the top stack item to before the second item, as [top next] -> [top next top].
  opTuck._internal(125),

  // [disabled] Concatenates two strings.
  opCat._internal(126),

  // [disabled] Returns a section of a string.
  opSubStr._internal(127),

  // [disabled] Keeps only characters left of the specified point in a string.
  opLeft._internal(128),

  // [disabled] Keeps only characters right of the specified point in a string.
  opRight._internal(129),

  // Pushes the string length of the top element of the stack (without popping it).
  opSize._internal(130),

  // [disabled] Flips all of the bits in the input.
  opInvert._internal(131),

  // [disabled] Boolean and between each bit in the inputs.
  opAnd._internal(132),

  // [disabled] Boolean or between each bit in the inputs.
  opOr._internal(133),

  // [disabled] Boolean exclusive or between each bit in the inputs.
  opXor._internal(134),

  // Returns 1 if the inputs are exactly equal, 0 otherwise.
  opEqual._internal(135),

  // Same as OP_EQUAL, but runs OP_VERIFY afterward.
  opEqualVerify._internal(136),

  // Synonym for OP_RETURN.
  opReserved1._internal(137),

  // Synonym for OP_RETURN.
  opReserved2._internal(138),

  // Increment the top stack element in place.
  op1Add._internal(139),

  // Decrement the top stack element in place.
  op1Sub._internal(140),

  // [disabled] Multiply the top stack element by 2 in place.
  op2Mul._internal(141),

  // [disabled] Divide the top stack element by 2 in place.
  op2Div._internal(142),

  // Multiply the top stack item by -1 in place.
  opNegate._internal(143),

  // Absolute value the top stack item in place.
  opAbs._internal(144),

  // Map 0 to 1 and everything else to 0, in place.
  opNot._internal(145),

  // Map 0 to 0 and everything else to 1, in place.
  op0NotEqual._internal(146),

  // Pop two stack items and push their sum.
  opAdd._internal(147),

  // Pop two stack items and push the second minus the top.
  opSub._internal(148),

  // [disabled] Pop two stack items and push their product.
  opMul._internal(149),

  // [disabled] Pop two stack items and push the second divided by the top.
  opDiv._internal(150),

  // [disabled] Pop two stack items and push the remainder after dividing the second by the top.
  opMod._internal(151),

  // [disabled]
  opLShift._internal(152),

  // [disabled]
  opRShift._internal(153),

  // Pop the top two stack items and push 1 if both are nonzero, else push 0.
  opBoolAnd._internal(154),

  // Pop the top two stack items and push 1 if either is nonzero, else push 0.
  opBoolOr._internal(155),

  // Pop the top two stack items and push 1 if they are equal, else push 0.
  opNumEqual._internal(156),

  // Pop the top two stack items and return success if both are numerically equal, else return failure.
  opNumEqualVerify._internal(157),

  // Pop the top two stack items and push 0 if both are numerically equal, else push 1.
  opNumNotEqual._internal(158),

  // Pop the top two items; push 1 if the second is less than the top, 0 otherwise.
  opLessThan._internal(159),

  // Pop the top two items; push 1 if the second is greater than the top, 0 otherwise.
  opGreaterThan._internal(160),

  // Pop the top two items; push 1 if the second is <= the top, 0 otherwise.
  opLessThanOrEqual._internal(161),

  // Pop the top two items; push 1 if the second is >= the top, 0 otherwise.
  opGreaterThanOrEqual._internal(162),

  // Pop the top two items; push the smaller.
  opMin._internal(163),

  // Pop the top two items; push the larger.
  opMax._internal(164),

  // Pop the top three items; if the top is >= the second and < the third, push 1, otherwise push 0.
  opWithin._internal(165),

  // Pop the top stack item and push its RIPEMD160 hash.
  opRipemd160._internal(166),

  // Pop the top stack item and push its SHA1 hash.
  opSha1._internal(167),

  // Pop the top stack item and push its SHA256 hash.
  opSha256._internal(168),

  // Pop the top stack item and push its RIPEMD(SHA256) hash.
  opHash160._internal(169),

  // Pop the top stack item and push its SHA256(SHA256) hash.
  opHash256._internal(170),

  // Ignore this and everything preceding when deciding what to sign when signature-checking.
  opCodeSeparator._internal(171),

  // <https://en.bitcoin.it/wiki/OP_CHECKSIG> pushing 1/0 for success/failure.
  opCheckSig._internal(172),

  // <https://en.bitcoin.it/wiki/OP_CHECKSIG> returning success/failure.
  opCheckSigVerify._internal(173),

  // Pop N, N pubkeys, M, M signatures, a dummy (due to bug in reference code), and verify that all M signatures are valid.
  // Push 1 for "all valid", 0 otherwise.
  opCheckMultiSig._internal(174),

  // Like the above but return success/failure.
  opCheckMultiSigVerify._internal(175),

  // Does nothing.
  opNop1._internal(176),

  // <https://github.com/bitcoin/bips/blob/master/bip-0065.mediawiki>
  opCheckLockTimeVerify._internal(177),

  // /// <https://github.com/bitcoin/bips/blob/master/bip-0112.mediawiki>
  opCheckSequenceVerify._internal(178),

  // Does nothing.
  opNop4._internal(179),

  // Does nothing.
  opNop5._internal(180),

  // Does nothing.
  opNop6._internal(181),

  // Does nothing.
  opNop7._internal(182),

  // Does nothing.
  opNop8._internal(183),

  // Does nothing.
  opNop9._internal(184),

  // Does nothing.
  opNop10._internal(185),

  // Every other opcode acts as OP_RETURN
  // OP_CHECKSIGADD post tapscript.
  opCheckSigAdd._internal(186),

  // Synonym for OP_RETURN.
  opReturn187._internal(187),

  // Synonym for OP_RETURN.
  opReturn188._internal(188),

  // Synonym for OP_RETURN.
  opReturn189._internal(189),

  // Synonym for OP_RETURN.
  opReturn190._internal(190),

  // Synonym for OP_RETURN.
  opReturn191._internal(191),

  // Synonym for OP_RETURN.
  opReturn192._internal(192),

  // Synonym for OP_RETURN.
  opReturn193._internal(193),

  // Synonym for OP_RETURN.
  opReturn194._internal(194),

  // Synonym for OP_RETURN.
  opReturn195._internal(195),

  // Synonym for OP_RETURN.
  opReturn196._internal(196),

  // Synonym for OP_RETURN.
  opReturn197._internal(197),

  // Synonym for OP_RETURN.
  opReturn198._internal(198),

  // Synonym for OP_RETURN.
  opReturn199._internal(199),

  // Synonym for OP_RETURN.
  opReturn200._internal(200),

  // Synonym for OP_RETURN.
  opReturn201._internal(201),

  // Synonym for OP_RETURN.
  opReturn202._internal(202),

  // Synonym for OP_RETURN.
  opReturn203._internal(203),

  // Synonym for OP_RETURN.
  opReturn204._internal(204),

  // Synonym for OP_RETURN.
  opReturn205._internal(205),

  // Synonym for OP_RETURN.
  opReturn206._internal(206),

  // Synonym for OP_RETURN.
  opReturn207._internal(207),

  // Synonym for OP_RETURN.
  opReturn208._internal(208),

  // Synonym for OP_RETURN.
  opReturn209._internal(209),

  // Synonym for OP_RETURN.
  opReturn210._internal(210),

  // Synonym for OP_RETURN.
  opReturn211._internal(211),

  // Synonym for OP_RETURN.
  opReturn212._internal(212),

  // Synonym for OP_RETURN.
  opReturn213._internal(213),

  // Synonym for OP_RETURN.
  opReturn214._internal(214),

  // Synonym for OP_RETURN.
  opReturn215._internal(215),

  // Synonym for OP_RETURN.
  opReturn216._internal(216),

  // Synonym for OP_RETURN.
  opReturn217._internal(217),

  // Synonym for OP_RETURN.
  opReturn218._internal(218),

  // Synonym for OP_RETURN.
  opReturn219._internal(219),

  // Synonym for OP_RETURN.
  opReturn220._internal(220),

  // Synonym for OP_RETURN.
  opReturn221._internal(221),

  // Synonym for OP_RETURN.
  opReturn222._internal(222),

  // Synonym for OP_RETURN.
  opReturn223._internal(223),

  // Synonym for OP_RETURN.
  opReturn224._internal(224),

  // Synonym for OP_RETURN.
  opReturn225._internal(225),

  // Synonym for OP_RETURN.
  opReturn226._internal(226),

  // Synonym for OP_RETURN.
  opReturn227._internal(227),

  // Synonym for OP_RETURN.
  opReturn228._internal(228),

  // Synonym for OP_RETURN.
  opReturn229._internal(229),

  // Synonym for OP_RETURN.
  opReturn230._internal(230),

  // Synonym for OP_RETURN.
  opReturn231._internal(231),

  // Synonym for OP_RETURN.
  opReturn232._internal(232),

  // Synonym for OP_RETURN.
  opReturn233._internal(233),

  // Synonym for OP_RETURN.
  opReturn234._internal(234),

  // Synonym for OP_RETURN.
  opReturn235._internal(235),

  // Synonym for OP_RETURN.
  opReturn236._internal(236),

  // Synonym for OP_RETURN.
  opReturn237._internal(237),

  // Synonym for OP_RETURN.
  opReturn238._internal(238),

  // Synonym for OP_RETURN.
  opReturn239._internal(239),

  // Synonym for OP_RETURN.
  opReturn240._internal(240),

  // Synonym for OP_RETURN.
  opReturn241._internal(241),

  // Synonym for OP_RETURN.
  opReturn242._internal(242),

  // Synonym for OP_RETURN.
  opReturn243._internal(243),

  // Synonym for OP_RETURN.
  opReturn244._internal(244),

  // Synonym for OP_RETURN.
  opReturn245._internal(245),

  // Synonym for OP_RETURN.
  opReturn246._internal(246),

  // Synonym for OP_RETURN.
  opReturn247._internal(247),

  // Synonym for OP_RETURN.
  opReturn248._internal(248),

  // Synonym for OP_RETURN.
  opReturn249._internal(249),

  // Synonym for OP_RETURN.
  opReturn250._internal(250),

  // Synonym for OP_RETURN.
  opReturn251._internal(251),

  // Synonym for OP_RETURN.
  opReturn252._internal(252),

  // Represents a public key hashed with OP_HASH160.
  opPubKeyHash._internal(253),

  // Represents a public key compatible with OP_CHECKSIG.
  opPubKey._internal(254),

  // Matches any opcode that is not yet assigned.
  opInvalidOpCode._internal(255);

  const OpCode._internal(this.code);

  factory OpCode.deserialize(Uint8List bytes) {
    if (bytes.length != bytesLength()) {
      throw ArgumentError('''
The length of given bytes is invalid
Expected: ${bytesLength()}, Actual: ${bytes.length}''');
    }

    final code = CreateInt.fromUint32leBytes(bytes);

    if (code < 0 || code > 255) {
      throw ArgumentError('"$code" is undefined OpCode code');
    }

    return _opCodes[code];
  }

  static const List<OpCode> _opCodes = [
    OpCode.opPushBytes0,
    OpCode.opPushBytes1,
    OpCode.opPushBytes2,
    OpCode.opPushBytes3,
    OpCode.opPushBytes4,
    OpCode.opPushBytes5,
    OpCode.opPushBytes6,
    OpCode.opPushBytes7,
    OpCode.opPushBytes8,
    OpCode.opPushBytes9,
    OpCode.opPushBytes10,
    OpCode.opPushBytes11,
    OpCode.opPushBytes12,
    OpCode.opPushBytes13,
    OpCode.opPushBytes14,
    OpCode.opPushBytes15,
    OpCode.opPushBytes16,
    OpCode.opPushBytes17,
    OpCode.opPushBytes18,
    OpCode.opPushBytes19,
    OpCode.opPushBytes20,
    OpCode.opPushBytes21,
    OpCode.opPushBytes22,
    OpCode.opPushBytes23,
    OpCode.opPushBytes24,
    OpCode.opPushBytes25,
    OpCode.opPushBytes26,
    OpCode.opPushBytes27,
    OpCode.opPushBytes28,
    OpCode.opPushBytes29,
    OpCode.opPushBytes30,
    OpCode.opPushBytes31,
    OpCode.opPushBytes32,
    OpCode.opPushBytes33,
    OpCode.opPushBytes34,
    OpCode.opPushBytes35,
    OpCode.opPushBytes36,
    OpCode.opPushBytes37,
    OpCode.opPushBytes38,
    OpCode.opPushBytes39,
    OpCode.opPushBytes40,
    OpCode.opPushBytes41,
    OpCode.opPushBytes42,
    OpCode.opPushBytes43,
    OpCode.opPushBytes44,
    OpCode.opPushBytes45,
    OpCode.opPushBytes46,
    OpCode.opPushBytes47,
    OpCode.opPushBytes48,
    OpCode.opPushBytes49,
    OpCode.opPushBytes50,
    OpCode.opPushBytes51,
    OpCode.opPushBytes52,
    OpCode.opPushBytes53,
    OpCode.opPushBytes54,
    OpCode.opPushBytes55,
    OpCode.opPushBytes56,
    OpCode.opPushBytes57,
    OpCode.opPushBytes58,
    OpCode.opPushBytes59,
    OpCode.opPushBytes60,
    OpCode.opPushBytes61,
    OpCode.opPushBytes62,
    OpCode.opPushBytes63,
    OpCode.opPushBytes64,
    OpCode.opPushBytes65,
    OpCode.opPushBytes66,
    OpCode.opPushBytes67,
    OpCode.opPushBytes68,
    OpCode.opPushBytes69,
    OpCode.opPushBytes70,
    OpCode.opPushBytes71,
    OpCode.opPushBytes72,
    OpCode.opPushBytes73,
    OpCode.opPushBytes74,
    OpCode.opPushBytes75,
    OpCode.opPushData1,
    OpCode.opPushData2,
    OpCode.opPushData4,
    OpCode.opPushNumNeg1,
    OpCode.opReserved,
    OpCode.opPushNum1,
    OpCode.opPushNum2,
    OpCode.opPushNum3,
    OpCode.opPushNum4,
    OpCode.opPushNum5,
    OpCode.opPushNum6,
    OpCode.opPushNum7,
    OpCode.opPushNum8,
    OpCode.opPushNum9,
    OpCode.opPushNum10,
    OpCode.opPushNum11,
    OpCode.opPushNum12,
    OpCode.opPushNum13,
    OpCode.opPushNum14,
    OpCode.opPushNum15,
    OpCode.opPushNum16,
    OpCode.opNop,
    OpCode.opVer,
    OpCode.opIf,
    OpCode.opNotIf,
    OpCode.opVerIf,
    OpCode.opVerNotIf,
    OpCode.opElse,
    OpCode.opEndIf,
    OpCode.opVerify,
    OpCode.opReturn,
    OpCode.opToAltStack,
    OpCode.opFromAltStack,
    OpCode.op2Drop,
    OpCode.op2Dup,
    OpCode.op3Dup,
    OpCode.op2Over,
    OpCode.op2Rot,
    OpCode.op2Swap,
    OpCode.opIfDup,
    OpCode.opDepth,
    OpCode.opDrop,
    OpCode.opDup,
    OpCode.opNip,
    OpCode.opOver,
    OpCode.opPick,
    OpCode.opRoll,
    OpCode.opRot,
    OpCode.opSwap,
    OpCode.opTuck,
    OpCode.opCat,
    OpCode.opSubStr,
    OpCode.opLeft,
    OpCode.opRight,
    OpCode.opSize,
    OpCode.opInvert,
    OpCode.opAnd,
    OpCode.opOr,
    OpCode.opXor,
    OpCode.opEqual,
    OpCode.opEqualVerify,
    OpCode.opReserved1,
    OpCode.opReserved2,
    OpCode.op1Add,
    OpCode.op1Sub,
    OpCode.op2Mul,
    OpCode.op2Div,
    OpCode.opNegate,
    OpCode.opAbs,
    OpCode.opNot,
    OpCode.op0NotEqual,
    OpCode.opAdd,
    OpCode.opSub,
    OpCode.opMul,
    OpCode.opDiv,
    OpCode.opMod,
    OpCode.opLShift,
    OpCode.opRShift,
    OpCode.opBoolAnd,
    OpCode.opBoolOr,
    OpCode.opNumEqual,
    OpCode.opNumEqualVerify,
    OpCode.opNumNotEqual,
    OpCode.opLessThan,
    OpCode.opGreaterThan,
    OpCode.opLessThanOrEqual,
    OpCode.opGreaterThanOrEqual,
    OpCode.opMin,
    OpCode.opMax,
    OpCode.opWithin,
    OpCode.opRipemd160,
    OpCode.opSha1,
    OpCode.opSha256,
    OpCode.opHash160,
    OpCode.opHash256,
    OpCode.opCodeSeparator,
    OpCode.opCheckSig,
    OpCode.opCheckSigVerify,
    OpCode.opCheckMultiSig,
    OpCode.opCheckMultiSigVerify,
    OpCode.opNop1,
    OpCode.opCheckLockTimeVerify,
    OpCode.opCheckSequenceVerify,
    OpCode.opNop4,
    OpCode.opNop5,
    OpCode.opNop6,
    OpCode.opNop7,
    OpCode.opNop8,
    OpCode.opNop9,
    OpCode.opNop10,
    OpCode.opCheckSigAdd,
    OpCode.opReturn187,
    OpCode.opReturn188,
    OpCode.opReturn189,
    OpCode.opReturn190,
    OpCode.opReturn191,
    OpCode.opReturn192,
    OpCode.opReturn193,
    OpCode.opReturn194,
    OpCode.opReturn195,
    OpCode.opReturn196,
    OpCode.opReturn197,
    OpCode.opReturn198,
    OpCode.opReturn199,
    OpCode.opReturn200,
    OpCode.opReturn201,
    OpCode.opReturn202,
    OpCode.opReturn203,
    OpCode.opReturn204,
    OpCode.opReturn205,
    OpCode.opReturn206,
    OpCode.opReturn207,
    OpCode.opReturn208,
    OpCode.opReturn209,
    OpCode.opReturn210,
    OpCode.opReturn211,
    OpCode.opReturn212,
    OpCode.opReturn213,
    OpCode.opReturn214,
    OpCode.opReturn215,
    OpCode.opReturn216,
    OpCode.opReturn217,
    OpCode.opReturn218,
    OpCode.opReturn219,
    OpCode.opReturn220,
    OpCode.opReturn221,
    OpCode.opReturn222,
    OpCode.opReturn223,
    OpCode.opReturn224,
    OpCode.opReturn225,
    OpCode.opReturn226,
    OpCode.opReturn227,
    OpCode.opReturn228,
    OpCode.opReturn229,
    OpCode.opReturn230,
    OpCode.opReturn231,
    OpCode.opReturn232,
    OpCode.opReturn233,
    OpCode.opReturn234,
    OpCode.opReturn235,
    OpCode.opReturn236,
    OpCode.opReturn237,
    OpCode.opReturn238,
    OpCode.opReturn239,
    OpCode.opReturn240,
    OpCode.opReturn241,
    OpCode.opReturn242,
    OpCode.opReturn243,
    OpCode.opReturn244,
    OpCode.opReturn245,
    OpCode.opReturn246,
    OpCode.opReturn247,
    OpCode.opReturn248,
    OpCode.opReturn249,
    OpCode.opReturn250,
    OpCode.opReturn251,
    OpCode.opReturn252,
    OpCode.opPubKeyHash,
    OpCode.opPubKey,
    OpCode.opInvalidOpCode
  ];

  static int bytesLength() => 4;

  final int code;

  Map<String, dynamic> toJson() => {'code': '${toString()}($code)'};

  Uint8List serialize() => code.toUint32leBytes();
}
