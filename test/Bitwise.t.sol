// SPDX-LICENSE-IDENTIFIER: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/Bitwise.sol";

contract BitwiseTest is Test {
    Bitwise bitwise;

    function setUp () public {
        bitwise = new Bitwise();
    }

    function testAddReadValue() public {
        bitwise.addValue(4, 2);
        assertEq(bitwise.getValue(2), 4, "Value should be 4 at slot 2");
    }

    function testGetValues() public {
        bitwise.addValue(3, 0);
        bitwise.addValue(5, 1);
        bitwise.addValue(7, 2);
        bitwise.addValue(9, 3);
        uint8[] memory values = bitwise.getAllValues();
        assertEq(values[0], 3, "Value should be 3 at slot 0");
        assertEq(values[1], 5, "Value should be 5 at slot 1");
    }


}
