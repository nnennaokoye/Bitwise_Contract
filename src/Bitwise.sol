// SPDX-LICENSE-IDENTIFIER: UNLICENSED
pragma solidity ^0.8.28;

contract Bitwise {
    uint256 public packed;

    function addValue(uint256 value, uint8 loc) public {
        require(loc < 32, "Slot must be less than 32");
        uint shift = uint256(loc) * 8;
        packed = packed | (uint256(value )<< shift);
    }

    function getValue(uint8 loc) public view returns (uint8) {
        require(loc < 32, "Slot must be less than 32");
        uint256 shift = uint256(loc) * 8;
        return uint8((packed >> shift) & 0xff);
    }

    function getAllValues() public view returns (uint8[] memory) {
        uint8[] memory values = new uint8[](32);
        for (uint8 loc = 0; loc < 32; loc++) {
            values[loc] = getValue(loc);
        }
        return values;
    }
}